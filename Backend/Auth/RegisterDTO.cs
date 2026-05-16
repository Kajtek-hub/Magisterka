namespace Backend.DTO;
using Backend.Models;
using System.ComponentModel.DataAnnotations;
public class RegisterDTO
{
    [Required]
    [MinLength(3, ErrorMessage = "Name (at least 3 characters)")]
    public string UserName { get; set; } = null!;

    [Required]
    [MinLength(6, ErrorMessage = "Password must be at least 6 characters long")]
    public string Password { get; set; } = null!;

    [Range(0, 150, ErrorMessage = "Enter the correct age")]
    public int Age { get; set; }

    [Required]
    public Sex Sex { get; set; }
}