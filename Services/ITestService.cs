using Backend.Models;
using Backend.DTO;
namespace Backend.Services;
public interface ITestService
{
    Task<List<Test>> GetAllAsync();
    Task<Test?> GetByIdAsync(Guid id);
    Task<Test> CreateAsync(AddTestDTO dto);
}