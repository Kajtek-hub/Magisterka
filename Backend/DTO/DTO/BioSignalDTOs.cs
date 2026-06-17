namespace Backend.DTO;

public class BioSignalUploadResultDTO
{
    public Guid Id { get; set; }
    public string FileName { get; set; } = null!;
    public long FileSizeBytes { get; set; }
    public DateTime RecordedAt { get; set; }
    public string DeviceType { get; set; } = null!;
}

public class BioSignalMetaDTO
{
    public Guid Id { get; set; }
    public string FileName { get; set; } = null!;
    public DateTime RecordedAt { get; set; }
    public string DeviceType { get; set; } = null!;
    public long FileSizeBytes { get; set; }
    public double? HeartRate { get; set; }
    public double? HRV { get; set; }
    public double? EegDelta { get; set; }
    public double? EegTheta { get; set; }
    public double? EegAlpha { get; set; }
    public double? EegBeta { get; set; }

    public string? EpochFeaturesJson { get; set; }
}

public class BioSignalRawDTO
{
    public Guid Id { get; set; }
    public string FileName { get; set; } = null!;
    public string DeviceType { get; set; } = null!;
    // Próbki do wykresu — timestamp + wartość
    public List<BioSample> Samples { get; set; } = new();
}

public class BioSample
{
    public double TimestampMs { get; set; }
    public double Value { get; set; }
}