namespace Backend.Models;

public class User : IBaseModel
{
    public Guid Id { get; set; }
    public string? UserName { get; set; }
    public int Age { get; set; }
    public Sex Sex { get; set; }
    public string? PasswordHash { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}

public enum Sex
{
    male,
    female,
    other,
}