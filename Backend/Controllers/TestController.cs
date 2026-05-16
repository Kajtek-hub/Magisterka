using Backend.DTO;
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

    // ── POST ─────────────────────────────────────────────

    [HttpPost("pvt")]
    public async Task<IActionResult> CreatePVT(PVTTestDTO dto)
    {
        var result = await _service.CreatePVTAsync(dto);
        return Ok(result);
    }

    [HttpPost("gonogo")]
    public async Task<IActionResult> CreateGoNoGo(GoNoGoTestDTO dto)
    {
        var result = await _service.CreateGoNoGoAsync(dto);
        return Ok(result);
    }

    [HttpPost("nback")]
    public async Task<IActionResult> CreateNBack(NBackTestDTO dto)
    {
        var result = await _service.CreateNBackAsync(dto);
        return Ok(result);
    }

    [HttpPost("stroop")]
    public async Task<IActionResult> CreateStroop(StroopTestDTO dto)
    {
        var result = await _service.CreateStroopAsync(dto);
        return Ok(result);
    }

    [HttpPost("kss")]
    public async Task<IActionResult> CreateKSS(KSSTestDTO dto)
    {
        var result = await _service.CreateKSSAsync(dto);
        return Ok(result);
    }

    // ── GET BY USER ───────────────────────────────────────

    [HttpGet("pvt/user/{userId}")]
    public async Task<IActionResult> GetPVTByUser(Guid userId)
    {
        var results = await _service.GetPVTByUserAsync(userId);
        return Ok(results);
    }

    [HttpGet("gonogo/user/{userId}")]
    public async Task<IActionResult> GetGoNoGoByUser(Guid userId)
    {
        var results = await _service.GetGoNoGoByUserAsync(userId);
        return Ok(results);
    }

    [HttpGet("nback/user/{userId}")]
    public async Task<IActionResult> GetNBackByUser(Guid userId)
    {
        var results = await _service.GetNBackByUserAsync(userId);
        return Ok(results);
    }

    [HttpGet("stroop/user/{userId}")]
    public async Task<IActionResult> GetStroopByUser(Guid userId)
    {
        var results = await _service.GetStroopByUserAsync(userId);
        return Ok(results);
    }

    [HttpGet("kss/user/{userId}")]
    public async Task<IActionResult> GetKSSByUser(Guid userId)
    {
        var results = await _service.GetKSSByUserAsync(userId);
        return Ok(results);
    }
}