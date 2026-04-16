namespace Backend.Patterns;
using Backend.Models;
public interface ITestStrategy
{
        
    string Name { get; }
    void Apply(Test test);
}

public class PvtStrategy : ITestStrategy
{
    public string Name => "PVT";

    public void Apply(Test test)
    {
        var engine = new RuleEngine<Test>()
            .IF(t => t.testResult <= 200)
                .THEN(t => t.testInterpretation = new FastTestReaction())

            .IF(t => t.testResult <= 350)
                .THEN(t => t.testInterpretation = new NormalTestReaction())

            .IF(t => t.testResult <= 500)
                .THEN(t => t.testInterpretation = new SlowTestReaction())

            .IF(t => t.testResult > 500)
                .THEN(t => t.testInterpretation = new LapseTestReaction());

        engine.EXECUTE(test);
    }
}

public class KSSStrategy : ITestStrategy
{
    public string Name => "KSS";

    public void Apply(Test test)
    {
        test.testInterpretation = new NormalTestReaction();
    }
}



public static class TestRuleSetFactory
{
    public static ITestStrategy Get(string type)
    {
        return type switch
        {
            "PVT" => new PvtStrategy(),
            "KSS" => new KSSStrategy(),
            _ => throw new ArgumentException("Unknown type")
        };
    }
}