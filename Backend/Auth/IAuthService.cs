using Backend.DTO;
using Backend.Models;

public interface IAuthService
{
    Task<User> RegisterAsync(RegisterDTO dto);
    Task<string> LoginAsync(LoginDTO dto);
}