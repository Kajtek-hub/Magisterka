using Backend.Models;
namespace Backend.Strategy;
public interface ITestStrategy
{
    int CalculateResult(int input);
}

public class PvtStrategy : ITestStrategy
{
    public int CalculateResult(int input)
    {
        return input;
    }
}

public class KSSStrategy : ITestStrategy
{
    public int CalculateResult(int input)
    {
        return Math.Clamp(input, 1, 9);
    }
}

public static class TestStrategyFactory
{
    public static ITestStrategy GetTestStrategy(TestType type)
    {
        return type switch
        {
            PVTTest => new PvtStrategy(),
            KSSTest => new KSSStrategy(),
            _ => throw new ArgumentException()
        };
    }
}