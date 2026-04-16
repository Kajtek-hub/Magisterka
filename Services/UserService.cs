using Backend.Models;
namespace Backend.Services;
public class UserService : IUserService
{
    private readonly List<User> _users = new();

    public Task<List<User>> GetAllAsync()
    {
        return Task.FromResult(_users);
    }

    public Task<User?> GetByIdAsync(Guid id)
    {
        var user = _users.FirstOrDefault(x => x.Id == id);
        return Task.FromResult(user);
    }

    public Task<User> CreateAsync(User user)
    {
        user.Id = Guid.NewGuid();
        _users.Add(user);
        return Task.FromResult(user);
    }
}