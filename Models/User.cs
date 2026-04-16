namespace Backend.Models;
public class User : IBaseModel
{
    public Guid Id {get; set;}
    public string? UserName {get; set;}
    public DateOnly DateOfBirth {get; set;} 
    public Sex Sex {get; set;}
    public string? Email {get; set;}
}

public enum Sex
{
    male,
    female,
    other,
}