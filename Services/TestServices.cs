using Backend.Models;
using Backend.DTO;
using Backend.Patterns;
using Backend.TestDDD;
namespace Backend.Services;
public class TestService : ITestService
{
    private readonly List<Test> _tests = new();
    private readonly IUserService _userService;
    private readonly TestDomainEventDispatcher _dispatcher;

public TestService(IUserService userService, TestDomainEventDispatcher dispatcher)
    {
        _userService = userService;
        _dispatcher = dispatcher;
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

    if (user == null)
        throw new Exception("User not found");

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

        var @event = new TestSettledEvent(
            test.UserId,
            test.testType,
            test.testResult,
            test.CreatedAt
        );
        _dispatcher.Publish(@event);

        return test;
    }
}
