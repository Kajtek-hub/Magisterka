
using Backend.Models;
using Backend.DTO;
namespace Backend.Services;
using Backend.Models;



public interface ITestService
{
    Task<PVTTest> CreatePVTAsync(PVTTest test);

    Task<GoNoGoTest> CreateGoNoGoAsync(GoNoGoTest test);

    Task<NBackTest> CreateNBackAsync(NBackTest test);

    Task<StroopTest> CreateStroopAsync(StroopTest test);

    Task<KSSTest> CreateKSSAsync(KSSTest test);
}