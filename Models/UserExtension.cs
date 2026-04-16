namespace Backend.Models;
public static class UserExtension
{
    public static string GetFullName(this User user)
    {
        return user.UserName;
    }

    public static int getAge(this User user)
    {
        var today = DateOnly.FromDateTime(DateTime.Today);
        var age = today.Year - user.DateOfBirth.Year;

        if (user.DateOfBirth > today.AddYears(-age))
        {
            age--;
        }
        return age;
    }
}
