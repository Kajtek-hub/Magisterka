using Backend.Data;
using Backend.DTO;
using Backend.Models;
using Microsoft.EntityFrameworkCore;
using System.Globalization;
using MathNet.Numerics.IntegralTransforms;
using System.Numerics;
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
                EpochFeaturesJson = r.EpochFeaturesJson,
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


// ── Parsowanie BITalino TXT ──────────────────────────
private static List<BioSample> ParseBItalinoSamples(byte[] data)
{
    var text = System.Text.Encoding.UTF8.GetString(data);
    var samples = new List<BioSample>();
    double ts = 0;
    const double sampleIntervalMs = 10.0; // 100Hz = 10ms

    foreach (var line in text.Split(
        new[] { "\r\n", "\n" }, StringSplitOptions.RemoveEmptyEntries))
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
    if (samples.Count < 3000) return;

    const int fs = 100;
    const int epochSamples = 3000;

    var epochCount = samples.Count / epochSamples;

    var deltaList   = new List<double>();
    var thetaList   = new List<double>();
    var alphaList   = new List<double>();
    var sigmaList   = new List<double>();
    var betaList    = new List<double>();
    var entropyList = new List<double>(); // ← DODAJ

    for (int e = 0; e < epochCount; e++)
    {
        var epoch = samples
            .Skip(e * epochSamples)
            .Take(epochSamples)
            .Select(s => s.Value)
            .ToArray();

        double mean = epoch.Average();
        epoch = epoch.Select(v => v - mean).ToArray();
        epoch = ApplyNotchFilter(epoch, fs, 50.0);
        epoch = ApplyBandpassFilter(epoch, fs, 0.5, 45.0);

        // ← Zapisz complex żeby użyć go do entropii
        var complex = epoch
            .Select(v => new Complex(v, 0))
            .ToArray();
        Fourier.Forward(complex, FourierOptions.Matlab);

        double delta = BandPower(complex, fs, epochSamples, 0.5, 4.0);
        double theta = BandPower(complex, fs, epochSamples, 4.0, 8.0);
        double alpha = BandPower(complex, fs, epochSamples, 8.0, 12.0);
        double sigma = BandPower(complex, fs, epochSamples, 12.0, 15.0);
        double beta  = BandPower(complex, fs, epochSamples, 15.0, 25.0);

        deltaList.Add(delta);
        thetaList.Add(theta);
        alphaList.Add(alpha);
        sigmaList.Add(sigma);
        betaList.Add(beta);
        entropyList.Add(SpectralEntropy(complex, epochSamples)); // ← DODAJ
    }

    r.EegDelta = Math.Round(deltaList.Average(), 4);
    r.EegTheta = Math.Round(thetaList.Average(), 4);
    r.EegAlpha = Math.Round(alphaList.Average(), 4);
    r.EegBeta  = Math.Round(betaList.Average(), 4);

    r.EpochFeaturesJson = System.Text.Json.JsonSerializer.Serialize(
        Enumerable.Range(0, epochCount).Select(i => new
        {
            epochIndex  = i,
            timestampS  = i * 30,
            delta       = Math.Round(deltaList[i], 6),
            theta       = Math.Round(thetaList[i], 6),
            alpha       = Math.Round(alphaList[i], 6),
            sigma       = Math.Round(sigmaList[i], 6),
            beta        = Math.Round(betaList[i],  6),
            thetaAlpha  = Math.Round(thetaList[i] / (alphaList[i] + 1e-10), 6),
            deltaBeta   = Math.Round(deltaList[i] / (betaList[i]  + 1e-10), 6),
            entropy     = Math.Round(entropyList[i], 6), 
        }).ToList()
    );
}


private static double SpectralEntropy(Complex[] fft, int n)
{
    var magnitudes = fft.Take(n / 2)
        .Select(c => c.Magnitude * c.Magnitude)
        .ToArray();

    double total = magnitudes.Sum() + 1e-10;

    return -magnitudes
        .Select(m => {
            double p = m / total;
            return p > 0 ? p * Math.Log2(p) : 0;
        })
        .Sum();
}
// ── Filtr Notch (usuwa zakłócenia sieci 50Hz) ────────
private static double[] ApplyNotchFilter(
    double[] signal, int fs, double freqHz)
{
    var complex = signal.Select(v => new Complex(v, 0)).ToArray();
    Fourier.Forward(complex, FourierOptions.Matlab);

    int n     = complex.Length;
    int bin   = (int)Math.Round(freqHz * n / (double)fs);
    int width = (int)Math.Round(1.0  * n / (double)fs); // ±1Hz

    for (int i = bin - width; i <= bin + width; i++)
    {
        if (i > 0 && i < n)     complex[i]     = Complex.Zero;
        if (n - i > 0 && n - i < n) complex[n - i] = Complex.Zero;
    }

    Fourier.Inverse(complex, FourierOptions.Matlab);
    return complex.Select(c => c.Real).ToArray();
}

// ── Filtr pasmowoprzepustowy (przez zerowanie FFT) ───
private static double[] ApplyBandpassFilter(
    double[] signal, int fs, double lowHz, double highHz)
{
    var complex = signal.Select(v => new Complex(v, 0)).ToArray();
    Fourier.Forward(complex, FourierOptions.Matlab);

    int n    = complex.Length;
    int iLow  = (int)Math.Round(lowHz  * n / (double)fs);
    int iHigh = (int)Math.Round(highHz * n / (double)fs);

    for (int i = 0; i < n; i++)
    {
        // Zeruj częstotliwości poza zakresem 0.5-45Hz
        if (i < iLow || i > iHigh)
        {
            if (i < n / 2)     complex[i]     = Complex.Zero;
            if (n - i < n / 2) complex[n - i] = Complex.Zero;
        }
    }

    Fourier.Inverse(complex, FourierOptions.Matlab);
    return complex.Select(c => c.Real).ToArray();
}

// ── Moc pasma z FFT ───────────────────────────────────
private static double BandPower(
    Complex[] fft, int fs, int n, double fMin, double fMax)
{
    int iMin = (int)Math.Round(fMin * n / (double)fs);
    int iMax = (int)Math.Round(fMax * n / (double)fs);

    return fft
        .Skip(iMin)
        .Take(iMax - iMin)
        .Sum(c => c.Magnitude * c.Magnitude) / n;
}
}