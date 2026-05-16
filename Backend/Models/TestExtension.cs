
namespace Backend.Models;

public class PVTTest : Test
{
    public int ReactionTime { get; set; }
}

public class GoNoGoTest : Test
{
    public int Hits { get; set; }
    public int Misses { get; set; }
    public int FalseAlarms { get; set; }
    public int CorrectRejections { get; set; }
}

public class NBackTest : Test
{
    public int Hits { get; set; }
    public int Misses { get; set; }
    public int FalseAlarms { get; set; }
}

public class StroopTest : Test
{
    public int Correct { get; set; }
    public int Incorrect { get; set; }
}

public class KSSTest : Test
{
    public int SleepinessLevel { get; set; }
}