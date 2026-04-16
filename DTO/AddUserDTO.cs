using Backend.Models;
namespace Backend.DTO;
 
public class AddUserDTO
{
    public string? UserName {get; set;}
    public DateOnly DateOfBirth {get; set;} 
    public Sex Sex {get; set;}
    public string? Email {get; set;}
}