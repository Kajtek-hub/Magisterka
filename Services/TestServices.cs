using Backend.Models;
using Backend.DTO;
using Backend.Patterns;
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

public Task<Test> CreateAsync(AddTestDTO dto)
{
    var strategy = TestStrategyFactory.Get(dto.TestType);

    var calculatedResult = strategy.CalculateResult(dto.testResult);

    var test = new Test
    {
        Id = Guid.NewGuid(),
        CreatedAt = DateTime.UtcNow,
        testType = dto.TestType,
        testResult = calculatedResult,
        UserId = dto.UserId
    };

    _tests.Add(test);

    return Task.FromResult(test);
}
}