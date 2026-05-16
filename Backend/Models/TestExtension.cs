
namespace Backend.Models;

public class PVTTest : Test
{
    public int AverageReactionTime { get; set; }

    public int Lapses { get; set; }

    public int FastestReaction { get; set; }

    public int SlowestReaction { get; set; }
}
public class GoNoGoTest : Test
{
    public int CorrectResponses { get; set; }

    public int IncorrectResponses { get; set; }

    public int MissedResponses { get; set; }

    public int AverageReactionTime { get; set; }
}
public class NBackTest : Test
{
    public int CorrectAnswers { get; set; }

    public int IncorrectAnswers { get; set; }

    public int AccuracyPercent { get; set; }
}

public class StroopTest : Test
{
    public int CongruentReactionTime { get; set; }

    public int IncongruentReactionTime { get; set; }

    public int Errors { get; set; }
}

public class KSSTest : Test
{
    public int SleepinessLevel { get; set; }
}