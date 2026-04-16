namespace Backend.Patterns;
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