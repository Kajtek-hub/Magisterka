using Backend.Models;
namespace Backend.Services;
public interface ITestService
{
    Task<List<Test>> GetAllAsync();
    Task<Test?> GetByIdAsync(Guid id);
    Task<Test> CreateAsync(Test test);
}