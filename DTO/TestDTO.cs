namespace Backend.DTO;
using Backend.Models;

public class TestDTO
{
    public Guid Id {get; set;}
    public TestType testType {get; set;}
    public int testResult {get; set;}
    public DateTime CreatedAt { get; set; }
    //public TestInterpretation? testInterpretation {get; set;}
    public Guid UserId {get; set;}
}
