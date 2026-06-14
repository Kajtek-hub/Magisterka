using Backend.DTO;

namespace Backend.Services;

public interface IBioSignalService
{
    Task<BioSignalUploadResultDTO> UploadAsync(
        Guid userId,
        string deviceType,
        string fileName,
        byte[] fileData);

    Task<List<BioSignalMetaDTO>> GetMetaByUserAsync(Guid userId);
    Task<BioSignalRawDTO> GetRawAsync(Guid recordingId);
}