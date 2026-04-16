using Backend.Models;
namespace Backend.Services;

public class TestService
{
    private readonly List<Test> _tests = new();

    public IEnumerable<Test> GetAll() => _tests;
    public Test? GetById(Guid id) => _tests.FirstOrDefault(x => x.Id == id);
    public Test Create(Test test)
    {
        test.Id = Guid.NewGuid();
        _tests.Add(test);
        return test;
    }
}