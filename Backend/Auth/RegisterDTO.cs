namespace Backend.DTO;
using Backend.Models;

public class RegisterDTO
{
    public string UserName { get; set; } = null!;
    public string Password { get; set; } = null!;
    public int Age { get; set; }
    public Sex Sex { get; set; }
}