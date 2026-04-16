    using System.Diagnostics.Eventing.Reader;

    namespace Backend.Models;
    public class Test : IBaseModel
    {
        public Guid Id {get; set;}
        public Guid UserId {get; set;}
        public TestType? testType {get; set;}
        public int testResult {get; set;}
        public DateTime CreatedAt { get; set; }
        public TestInterpretation? testInterpretation {get; set;}
    }

    public abstract record TestType()
    {
        public abstract string Type {get;}
        public virtual void Interpretation(Test test){}
    }

    public record PVTTest : TestType
    {
        public override string Type => "PVT";
        public override void Interpretation(Test test)
        {
            var engine = new RuleEngine<Test>()
            .IF(t => t.testResult <= 200).THEN(t => t.testInterpretation = new FastTestReaction())
            .IF(t => t.testResult > 200 && t.testResult <= 350).THEN(t => t.testInterpretation = new NormalTestReaction())
            .IF(t => t.testResult > 350 && t.testResult <= 500).THEN(t => t.testInterpretation = new SlowTestReaction())
            .IF(t => t.testResult > 500).THEN(t=> t.testInterpretation = new LapseTestReaction());
            
            engine.EXECUTE(test);
        }
    }

    public record KSSTest : TestType
    {
        public override string Type => "KSS";
    }

    public abstract record TestInterpretation()
    {
        public abstract string Description {get;}
        public virtual bool IsCritical => false;
    };
    public record FastTestReaction : TestInterpretation
    {
        public override string Description => "Very fast reaction";
    };

    public record NormalTestReaction : TestInterpretation
    {
        public override string Description => "Normal reaction";
    };

    public record SlowTestReaction : TestInterpretation
    {
        public override string Description => "Slow reaction";
    };

    public record LapseTestReaction : TestInterpretation
    {
        public override string Description => "Lapse (attention failure)";
        public override bool IsCritical => true;
    };

