using Backend.Services;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers;

[ApiController]
[Route("api/biosignal")]
public class BioSignalController : ControllerBase
{
    private readonly IBioSignalService _service;

    public BioSignalController(IBioSignalService service)
    {
        _service = service;
    }

    // POST api/biosignal/upload
    // multipart/form-data: userId, deviceType, file
    [HttpPost("upload")]
    public async Task<IActionResult> Upload(
        [FromForm] Guid userId,
        [FromForm] string deviceType,
        IFormFile file)
    {
        if (file == null || file.Length == 0)
            return BadRequest("Brak pliku");

        using var ms = new MemoryStream();
        await file.CopyToAsync(ms);

        try
        {
            var result = await _service.UploadAsync(
                userId, deviceType, file.FileName, ms.ToArray());
            return Ok(result);
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }
    }

    // GET api/biosignal/user/{userId}
    [HttpGet("user/{userId}")]
    public async Task<IActionResult> GetByUser(Guid userId)
    {
        var results = await _service.GetMetaByUserAsync(userId);
        return Ok(results);
    }

    // GET api/biosignal/raw/{id}
    [HttpGet("raw/{id}")]
    public async Task<IActionResult> GetRaw(Guid id)
    {
        try
        {
            var result = await _service.GetRawAsync(id);
            return Ok(result);
        }
        catch (Exception ex)
        {
            return NotFound(ex.Message);
        }
    }
}