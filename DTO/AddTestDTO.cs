namespace Backend.DTO;
using Backend.Models;

public class AddTestDTO
{
    public TestType testType {get; set;}
    public int testResult {get; set;}
    public DateTime CreatedAt { get; set; }
    //public TestInterpretation? testInterpretation {get; set;}

    public Guid UserId {get; set;}
}