namespace Backend.TestDDD;
public class TestStatsProjection
{
    public Guid UserId { get; set; }
    public int TotalTests { get; set; }
    public int AverageResult { get; set; }

    private int _sum = 0;

    public static TestStatsProjection CreateEmpty(Guid userId)
        => new()
        {
            UserId = userId,
            TotalTests = 0,
            AverageResult = 0
        };

    public void Apply(TestSettledEvent e)
    {
        TotalTests++;
        _sum += e.Result;
        AverageResult = _sum / TotalTests;
    }
}