using Backend.Models;
namespace Backend.DTO;

public class UserDetailsDTO
{
    public Guid Id { get; set; }
    public string UserName { get; set; }
    public int Age { get; set; }
    public string Email { get; set; } 
    public Sex Sex { get; set; }
}
public class ReadUserDTO
{
    public Guid Id {get; set;}
    public string UserName {get; set;}
    public int Age {get; set;} 
}
public class AddUserDTO
{
    public string UserName { get; set; }
    public DateOnly DateOfBirth { get; set; }
    public Sex Sex { get; set; }
    public string Email { get; set; }
}

public class UpdateUserDTO
{
    public string UserName { get; set; }
    public string Email { get; set; }
}

