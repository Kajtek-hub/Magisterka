namespace Backend.Models;
public class Test : IBaseModel
{
    public Guid Id {get; set;}
    public string testType {get; set;}
    public int testResult {get; set;}
    public DateTime CreatedAt { get; set; }
    public TestInterpretation? testInterpretation {get; set;}

    public Guid UserId {get; set;}
    public User? user {get; set;}
}



