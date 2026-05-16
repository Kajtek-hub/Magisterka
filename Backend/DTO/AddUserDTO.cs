namespace Backend.DTO;
using Backend.Models;

public class AddUserDTO
{
    public required string UserName { get; set; }
    public int Age { get; set; }
    public Sex Sex { get; set; }
    public required string PasswordHash { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}