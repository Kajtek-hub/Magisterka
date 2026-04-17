using Microsoft.AspNetCore.Mvc;
using Backend.TestDDD;
namespace Backend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class StatsController : ControllerBase
{
    private readonly TestProjectionStore _store;

    public StatsController(TestProjectionStore store)
    {
        _store = store;
    }

    [HttpGet("{userId}")]
    public IActionResult GetStats(Guid userId)
    {
        var stats = _store.Get(userId);

        if (stats == null)
            return NotFound("No stats yet");

        return Ok(stats);
    }
}