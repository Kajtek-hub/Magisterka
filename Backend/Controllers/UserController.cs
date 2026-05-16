using Backend.DTO;
using Backend.Models;
using Backend.Patterns;
using Backend.Services;
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
            Age = u.Age,
            Sex = u.Sex,
        });

        return Ok(result);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var user = await _userService.GetByIdAsync(id);

        if (user == null)
            return NotFound();

        return Ok(new UserDTO
        {
            Id = user.Id,
            UserName = user.UserName,
            Age = user.Age,
            Sex = user.Sex,
        });
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
            Age = created.Age,
            Sex = created.Sex,
        });
    }
}