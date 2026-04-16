using Backend.Models;
namespace Backend.Services;
public class TestService : ITestService
{
    private readonly List<Test> _tests = new();

    public Task<List<Test>> GetAllAsync()
    {
        return Task.FromResult(_tests);
    }

    public Task<Test?> GetByIdAsync(Guid id)
    {
        var test = _tests.FirstOrDefault(x => x.Id == id);
        return Task.FromResult(test);
    }

    public Task<Test> CreateAsync(Test test)
    {
        test.Id = Guid.NewGuid();
        test.CreatedAt = DateTime.UtcNow;

        _tests.Add(test);
        return Task.FromResult(test);
    }
}