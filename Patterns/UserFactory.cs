using Backend.DTO;
using Backend.Models;

public static class UserFactory
{
    public static User Create(AddUserDTO x)
    {
        return new User
        {
            Id = Guid.NewGuid(),
            UserName = x.UserName,
            DateOfBirth = x.DateOfBirth,
            Sex = x.Sex,
            Email = x.Email
        };
    }
}