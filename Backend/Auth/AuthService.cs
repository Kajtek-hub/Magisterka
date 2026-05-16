using Backend.DTO;
using Backend.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace Backend.Services;

public class AuthService : IAuthService
{
    private readonly AuthDbContext _context;
    private readonly IConfiguration _config;
    private readonly PasswordHasher<User> _hasher = new();

    public AuthService(AuthDbContext context, IConfiguration config)
    {
        _context = context;
        _config = config;
    }

    public async Task<User> RegisterAsync(RegisterDTO dto)
    {
        if (string.IsNullOrWhiteSpace(dto.UserName))
            throw new Exception("The username cannot be empty");

        if (dto.Password.Length < 6)
            throw new Exception("Password must be at least 6 characters long");

        if (dto.Age < 0 || dto.Age > 150)
            throw new Exception("Enter the correct age");
        var existingUser = await _context.Users
            .FirstOrDefaultAsync(u => u.UserName == dto.UserName);

        if (existingUser != null)
            throw new Exception("A user with that name already exists");

        var user = new User
        {
            Id = Guid.NewGuid(),
            UserName = dto.UserName,
            Age = dto.Age,
            Sex = dto.Sex,
            PasswordHash = _hasher.HashPassword(new User(), dto.Password)
        };

        _context.Users.Add(user);

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateException)
        {
            // łapie duplikat który przeszedł przez sprawdzenie wyżej
            // (np. równoczesne zapytania)
            throw new Exception("A user with that name already exists");
        }

        return user;
    }

    public async Task<string> LoginAsync(LoginDTO dto)
    {
        var user = await _context.Users
            .FirstOrDefaultAsync(x => x.UserName == dto.UserName);

        if (user == null)
            throw new Exception("Incorrect login credentials");

        var result = _hasher.VerifyHashedPassword(user, user.PasswordHash!, dto.Password);

        if (result == PasswordVerificationResult.Failed)
            throw new Exception("Incorrect login credentials");

        return GenerateJwt(user);
    }

    private string GenerateJwt(User user)
    {
        var key = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(_config["Jwt:Key"]!));

        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new Claim(ClaimTypes.Name, user.UserName!)
        };

        var token = new JwtSecurityToken(
            issuer: _config["Jwt:Issuer"],
            audience: _config["Jwt:Audience"],
            claims: claims,
            expires: DateTime.Now.AddHours(1),
            signingCredentials: creds
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}