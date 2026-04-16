namespace Backend.Models;

public abstract record TestInterpretation
{
    public abstract string Description { get; }
    public virtual bool IsCritical => false;
}

public record FastTestReaction : TestInterpretation
{
    public override string Description => "Very fast reaction";
}

public record NormalTestReaction : TestInterpretation
{
    public override string Description => "Normal reaction";
}

public record SlowTestReaction : TestInterpretation
{
    public override string Description => "Slow reaction";
}

public record LapseTestReaction : TestInterpretation
{
    public override string Description => "Lapse (attention failure)";
    public override bool IsCritical => true;
}