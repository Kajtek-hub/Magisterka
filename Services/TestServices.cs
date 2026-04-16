using Backend.Models;
using Backend.DTO;
using Backend.Patterns;
namespace Backend.Services;
public class TestService : ITestService
{
    private readonly List<Test> _tests = new();
    
    private readonly IUserService _userService;

    public TestService(IUserService userService)
    {
        _userService = userService;
    }
    public Task<List<Test>> GetAllAsync()
    {
        return Task.FromResult(_tests);
    }

    public Task<Test?> GetByIdAsync(Guid id)
    {
        var test = _tests.FirstOrDefault(x => x.Id == id);
        return Task.FromResult(test);
    }

public async Task<Test> CreateAsync(AddTestDTO dto)
{
        var user = await _userService.GetByIdAsync(dto.UserId);


        var test = new Test
        {
            Id = Guid.NewGuid(),
            CreatedAt = DateTime.UtcNow,
            testType = dto.testType,
            testResult = dto.testResult,
            UserId = user.Id,
            user = user
        };

        var ruleSet = TestRuleSetFactory.Get(dto.testType);
        ruleSet.Apply(test);

        _tests.Add(test);

        return test;
    }
}
