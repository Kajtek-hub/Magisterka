using Backend.Data;
using Backend.DTO;
using Backend.Models;
using Microsoft.EntityFrameworkCore;
using System.Globalization;

namespace Backend.Services;

public class BioSignalService : IBioSignalService
{
    private readonly BioSignalDbContext _context;

    public BioSignalService(BioSignalDbContext context)
    {
        _context = context;
    }

    public async Task<BioSignalUploadResultDTO> UploadAsync(
        Guid userId, string deviceType, string fileName, byte[] fileData)
    {
        if (!Enum.TryParse<DeviceType>(deviceType, true, out var device))
            throw new Exception($"Nieznany typ urządzenia: {deviceType}");

        var recording = new BioSignalRecording
        {
            UserId = userId,
            DeviceType = device,
            FileName = fileName,
            FileData = fileData,
            FileSizeBytes = fileData.Length,
        };

        // Oblicz metryki od razu po zapisie
        if (device == DeviceType.Movesense)
            ParseMovesenseMetrics(recording, fileData);
        else
            ParseBItalinoMetrics(recording, fileData);

        _context.Recordings.Add(recording);
        await _context.SaveChangesAsync();

        return new BioSignalUploadResultDTO
        {
            Id = recording.Id,
            FileName = recording.FileName,
            FileSizeBytes = recording.FileSizeBytes,
            RecordedAt = recording.RecordedAt,
            DeviceType = recording.DeviceType.ToString(),
        };
    }

    public async Task<List<BioSignalMetaDTO>> GetMetaByUserAsync(Guid userId)
    {
        // Nie ładuj FileData — tylko metadane i metryki
        return await _context.Recordings
            .Where(r => r.UserId == userId)
            .OrderByDescending(r => r.RecordedAt)
            .Select(r => new BioSignalMetaDTO
            {
                Id = r.Id,
                FileName = r.FileName,
                RecordedAt = r.RecordedAt,
                DeviceType = r.DeviceType.ToString(),
                FileSizeBytes = r.FileSizeBytes,
                HeartRate = r.HeartRate,
                HRV = r.HRV,
                EegDelta = r.EegDelta,
                EegTheta = r.EegTheta,
                EegAlpha = r.EegAlpha,
                EegBeta = r.EegBeta,
            })
            .ToListAsync();
    }

    public async Task<BioSignalRawDTO> GetRawAsync(Guid recordingId)
    {
        var recording = await _context.Recordings.FindAsync(recordingId)
            ?? throw new Exception("Nagranie nie znalezione");

        var samples = recording.DeviceType == DeviceType.Movesense
            ? ParseMovesenseSamples(recording.FileData)
            : ParseBItalinoSamples(recording.FileData);

        return new BioSignalRawDTO
        {
            Id = recording.Id,
            FileName = recording.FileName,
            DeviceType = recording.DeviceType.ToString(),
            Samples = samples,
        };
    }

    // ── Parsowanie Movesense CSV ─────────────────────────
    // Format: timestamp_ms,ecg_value
    private static List<BioSample> ParseMovesenseSamples(byte[] data)
    {
        var text = System.Text.Encoding.UTF8.GetString(data);
        var samples = new List<BioSample>();

        foreach (var line in text.Split('\n').Skip(1)) // pomijamy nagłówek
        {
            var parts = line.Trim().Split(',');
            if (parts.Length < 2) continue;
            if (!double.TryParse(parts[0], NumberStyles.Any, CultureInfo.InvariantCulture, out var ts)) continue;
            if (!double.TryParse(parts[1], NumberStyles.Any, CultureInfo.InvariantCulture, out var val)) continue;
            samples.Add(new BioSample { TimestampMs = ts, Value = val });
        }

        return samples;
    }

    private static void ParseMovesenseMetrics(BioSignalRecording r, byte[] data)
    {
        var samples = ParseMovesenseSamples(data);
        if (samples.Count < 2) return;

        // Prosta detekcja R-peaks — szukaj lokalnych maksimów > próg
        var values = samples.Select(s => s.Value).ToList();
        double threshold = values.Average() + values.Select(v => Math.Abs(v - values.Average())).Average();
        var rPeakTimes = new List<double>();

        for (int i = 1; i < samples.Count - 1; i++)
        {
            if (samples[i].Value > threshold &&
                samples[i].Value > samples[i - 1].Value &&
                samples[i].Value > samples[i + 1].Value)
            {
                rPeakTimes.Add(samples[i].TimestampMs);
            }
        }

        if (rPeakTimes.Count < 2) return;

        var rrIntervals = rPeakTimes.Zip(rPeakTimes.Skip(1), (a, b) => b - a).ToList();
        r.HeartRate = Math.Round(60000.0 / rrIntervals.Average(), 1);
        r.HRV = Math.Round(Math.Sqrt(rrIntervals.Select(rr => Math.Pow(rr, 2)).Average()), 2);
    }

    // ── Parsowanie BITalino TXT ──────────────────────────
    // Format: # nagłówki, potem: nSeq  DI1  DI2  A1  A2  A3  A4  A5  A6
    private static List<BioSample> ParseBItalinoSamples(byte[] data)
    {
        var text = System.Text.Encoding.UTF8.GetString(data);
        var samples = new List<BioSample>();
        double ts = 0;
        const double sampleIntervalMs = 10.0; // 100 Hz = 10ms

        // Split obsługuje zarówno \r\n (Windows) jak i \n (Linux)
        foreach (var line in text.Split(new[] { "\r\n", "\n" }, StringSplitOptions.RemoveEmptyEntries))
        {
            if (line.StartsWith('#') || string.IsNullOrWhiteSpace(line)) continue;

            var parts = line.Trim().Split('\t');
            if (parts.Length < 6) continue;

            if (!double.TryParse(parts[5], NumberStyles.Any,
                CultureInfo.InvariantCulture, out var val)) continue;

            samples.Add(new BioSample { TimestampMs = ts, Value = val });
            ts += sampleIntervalMs;
        }

        return samples;
    }

    private static void ParseBItalinoMetrics(BioSignalRecording r, byte[] data)
    {
        var samples = ParseBItalinoSamples(data);
        if (samples.Count < 512) return;

        // Prosta aproksymacja pasm przez wariancję w oknach
        // W produkcji użyj FFT (np. MathNet.Numerics)
        var values = samples.Select(s => s.Value).ToArray();
        double mean = values.Average();
        double variance = values.Select(v => Math.Pow(v - mean, 2)).Average();

        // Placeholder — zastąp prawdziwym FFT
        r.EegDelta = Math.Round(variance * 0.40, 4);
        r.EegTheta = Math.Round(variance * 0.25, 4);
        r.EegAlpha = Math.Round(variance * 0.20, 4);
        r.EegBeta  = Math.Round(variance * 0.15, 4);
    }
}