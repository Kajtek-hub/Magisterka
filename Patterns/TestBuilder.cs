using Backend.Models;

public class TestBuilder
{
    private readonly Test _test = new();
    public TestBuilder ForUser(Guid userID)
    {
       _test.UserId = userID;
       return this; 
    }
    public TestBuilder WithType (TestType type)
    {
        _test.testType = type;
        return this;
    }

    public TestBuilder WithResult (int result)
    {
        _test.testResult = result;
        return this;
    }

    public Test Build()
    {
        _test.Id = Guid.NewGuid();
        _test.CreatedAt = DateTime.UtcNow;
        return _test;
    }
}