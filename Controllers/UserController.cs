using Microsoft.AspNetCore.Mvc;
using Backend.Services;
using Backend.DTO;
using Backend.Models;

namespace Backend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase
{
    private readonly UserService _userService;
    public UserController (UserService userService)
    {
        _userService = userService;
    }

    [HttpGet]
    public ActionResult <IEnumerable<ReadUserDTO>> GetAll()
    {
        var users = _userService.GetAll();
        var result = users.Select(x => new ReadUserDTO
        {
           Id = x.Id,
           UserName = x.UserName,
           Age = x.getAge() 
        });

        return Ok(result);
    }

    [HttpGet("{id}")]
    public ActionResult<ReadUserDTO> GetById(Guid id)
    {
        var user = _userService.GetById(id);
        if (user == null)
        {
            return NotFound();
        }

        var result = new ReadUserDTO
        {
            Id = user.Id,
            UserName = user.UserName,
            Age = user.getAge()
        };

        return result;
    }

    [HttpPost]
    public IActionResult Add(AddUserDTO x)
    {
        var user = UserFactory.Create(x);
        _userService.Create(user);

        return Ok();
    }

    [HttpPut]
    public ActionResult Update(Guid id, UpdateUserDTO x)
    {
        var user = _userService.GetById(id);
        if(user == null) return NotFound();
        user.UserName = x.UserName;
        user.Email = x.Email;

        return Ok(user.Id);
    }
}