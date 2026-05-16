namespace Backend.DTO;

public class PVTTestDTO
{
    public Guid UserId { get; set; }
    public int ReactionTime { get; set; }
}

public class GoNoGoTestDTO
{
    public Guid UserId { get; set; }
    public int Hits { get; set; }
    public int Misses { get; set; }
    public int FalseAlarms { get; set; }
    public int CorrectRejections { get; set; }
}

public class NBackTestDTO
{
    public Guid UserId { get; set; }
    public int Hits { get; set; }
    public int Misses { get; set; }
    public int FalseAlarms { get; set; }
}

public class StroopTestDTO
{
    public Guid UserId { get; set; }
    public int Correct { get; set; }
    public int Incorrect { get; set; }
}

public class KSSTestDTO
{
    public Guid UserId { get; set; }
    public int SleepinessLevel { get; set; }
}

// Wspólny DTO do zwracania wyników — używany przy GET
public class TestResultDTO
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    public DateTime CreatedAt { get; set; }
    public string TestType { get; set; } = null!;
    public Dictionary<string, int> Results { get; set; } = new();
}
