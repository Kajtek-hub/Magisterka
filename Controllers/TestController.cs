using Backend.Models;
using Backend.Services;
using Microsoft.AspNetCore.Mvc;
namespace Backend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TestController : ControllerBase
{
    private readonly ITestService _testService;

    public TestController(ITestService testService)
    {
        _testService = testService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var tests = await _testService.GetAllAsync();
        return Ok(tests);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var test = await _testService.GetByIdAsync(id);

        if (test == null)
            return NotFound();

        return Ok(test);
    }

    [HttpPost]
    public async Task<IActionResult> Create(Test test)
    {
        var created = await _testService.CreateAsync(test);
        return Ok(created);
    }
}