namespace Backend.Models;



public class BioSignalRecording : IBaseModel
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid UserId { get; set; }
    public DeviceType DeviceType { get; set; }
    public DateTime RecordedAt { get; set; } = DateTime.UtcNow;
    public string FileName { get; set; } = null!;
    public byte[] FileData { get; set; } = null!;   
    public long FileSizeBytes { get; set; }

    
    public double? HeartRate { get; set; }           
    public double? HRV { get; set; }                 
    public double? EegDelta { get; set; }            
    public double? EegTheta { get; set; }            
    public double? EegAlpha { get; set; }            
    public double? EegBeta { get; set; }   

    public string? EpochFeaturesJson { get; set; }          
}

public enum DeviceType { Movesense, BITalino }