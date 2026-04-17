using Backend.Models;
using Backend.Services;
using Backend.DTO;
using Backend.Patterns;
using Microsoft.AspNetCore.Mvc;
namespace Backend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase
{
    private readonly IUserService _userService;

    public UserController(IUserService userService)
    {
        _userService = userService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var users = await _userService.GetAllAsync();

        var result = users.Select(u => new UserDTO
        {
            Id = u.Id,
            UserName = u.UserName,
            Age = u.GetAge(),
            Sex = u.Sex,
            Email = u.Email
        });

        return Ok(result);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var user = await _userService.GetByIdAsync(id);

        if (user == null)
            return NotFound();

        var result = new UserDTO
        {
            Id = user.Id,
            UserName = user.UserName,
            Age = user.GetAge(),
            Sex = user.Sex,
            Email = user.Email
        };

        return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> Create(AddUserDTO dto)
    {
        var user = UserFactory.Create(dto);

        var created = await _userService.CreateAsync(user);

        return Ok(new UserDTO
        {
            Id = created.Id,
            UserName = created.UserName,
            Age = created.GetAge(),
            Sex = created.Sex,
            Email = created.Email
        });
    }
}