namespace Backend.DTO;
using Backend.Models;

public class UserDTO
{
    public Guid Id { get; set; }
    public string? UserName { get; set; }
    public int Age { get; set; }
    public Sex Sex { get; set; }
}