using Backend.Models;
using Backend.Services;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers;

[ApiController]
[Route("api/tests")]
public class TestController : ControllerBase
{
    private readonly ITestService _service;

    public TestController(ITestService service)
    {
        _service = service;
    }

    [HttpPost("pvt")]
    public async Task<IActionResult> CreatePVT(PVTTest test)
    {
        var created = await _service.CreatePVTAsync(test);

        return Ok(created);
    }

    [HttpPost("gonogo")]
    public async Task<IActionResult> CreateGoNoGo(GoNoGoTest test)
    {
        var created = await _service.CreateGoNoGoAsync(test);

        return Ok(created);
    }

    [HttpPost("nback")]
    public async Task<IActionResult> CreateNBack(NBackTest test)
    {
        var created = await _service.CreateNBackAsync(test);

        return Ok(created);
    }

    [HttpPost("stroop")]
    public async Task<IActionResult> CreateStroop(StroopTest test)
    {
        var created = await _service.CreateStroopAsync(test);

        return Ok(created);
    }

    [HttpPost("kss")]
    public async Task<IActionResult> CreateKSS(KSSTest test)
    {
        var created = await _service.CreateKSSAsync(test);

        return Ok(created);
    }
}