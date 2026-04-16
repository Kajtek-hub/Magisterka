using Backend.Models;

namespace Backend.Services;

public class UserService
{
    private readonly List<User> _users = new();

    public IEnumerable<User> GetAll() => _users;
    public User? GetById(Guid id) => _users.FirstOrDefault(x => x.Id == id);
    public User Create (User user)
    {
        user.Id = Guid.NewGuid();
        _users.Add(user);
        return user;
    }
}