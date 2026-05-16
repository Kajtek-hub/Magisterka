using Backend.DTO;
using Backend.Models;

namespace Backend.Patterns;

public static class UserFactory
{
    public static User Create(AddUserDTO x)
    {
        return new User
        {
            Id = Guid.NewGuid(),
            UserName = x.UserName,
            Age = x.Age,
            Sex = x.Sex,
            PasswordHash = x.PasswordHash,
        };
    }
}