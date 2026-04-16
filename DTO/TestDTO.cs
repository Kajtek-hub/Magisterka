using Backend.Models;

namespace Backend.DTO;

public class ReadTestDTO
{   
    public Guid Id { get; set; }
    public string? testType {get; set;}
    public int testResult {get; set;}
    public DateTime CreatedAt { get; set; }
    
    public string? Interpretation { get; set; }

}

public class AddTestDTO
{
    public TestType? testType {get; set;}
    public int testResult {get; set;}
    public Guid UserId {get; set;}

}
