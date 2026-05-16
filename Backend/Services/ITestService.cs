using Backend.DTO;
using Backend.Models;

namespace Backend.Services;

public interface ITestService
{
    Task<TestResultDTO> CreatePVTAsync(PVTTestDTO dto);
    Task<TestResultDTO> CreateGoNoGoAsync(GoNoGoTestDTO dto);
    Task<TestResultDTO> CreateNBackAsync(NBackTestDTO dto);
    Task<TestResultDTO> CreateStroopAsync(StroopTestDTO dto);
    Task<TestResultDTO> CreateKSSAsync(KSSTestDTO dto);

    Task<List<TestResultDTO>> GetPVTByUserAsync(Guid userId);
    Task<List<TestResultDTO>> GetGoNoGoByUserAsync(Guid userId);
    Task<List<TestResultDTO>> GetNBackByUserAsync(Guid userId);
    Task<List<TestResultDTO>> GetStroopByUserAsync(Guid userId);
    Task<List<TestResultDTO>> GetKSSByUserAsync(Guid userId);
}