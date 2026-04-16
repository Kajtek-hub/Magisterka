namespace Backend.DTO;
using Backend.Models;
public class UserDTO
{
    public Guid Id {get; set;}
    public string? UserName {get; set;}
    public DateOnly DateOfBirth {get; set;} 
    public Sex Sex {get; set;}
    public string? Email {get; set;}
}