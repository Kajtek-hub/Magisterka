using Microsoft.AspNetCore.Mvc;
using Backend.Services;
using Backend.DTO;
using Backend.Strategy;
using Backend.Validation;

namespace Backend.Controllers;

[ApiController]
[Route("api/[controller]")]

public class TestController : ControllerBase
{
    private readonly TestService _testservices;
    private readonly IValidator<AddTestDTO> _testValidator;
    public TestController(TestService testService, IValidator<AddTestDTO> testValidator)
    {
        _testservices = testService;
        _testValidator = testValidator;
    }

    [HttpGet]
    public ActionResult <IEnumerable<ReadTestDTO>> GetAll()
    {
        var tests = _testservices.GetAll();
        var result = tests.Select(x => new ReadTestDTO{
           Id = x.Id,
           testType = x.testType?.Type,
           testResult = x.testResult,
           CreatedAt = x.CreatedAt,
           Interpretation = x.testInterpretation?.Description
           
        });

        return Ok(result);
    }

    [HttpGet("{id}")]
    public ActionResult <ReadTestDTO> GetById(Guid id)
    {
        var test = _testservices.GetById(id);
        if(test == null) return NotFound();

        var result = new ReadTestDTO
        {
          Id = test.Id,
          testResult = test.testResult,
          testType = test.testType?.Type,
          CreatedAt = test.CreatedAt,  
          Interpretation = test.testInterpretation?.Description
        };

        return result;
    }

    [HttpPost]
    public IActionResult Create(AddTestDTO x)
    {
        var validation = _testValidator.Validate(x);  
        if(!validation.IsValid) return BadRequest(validation.Erros);  
        
        var strategy = TestStrategyFactory.GetTestStrategy(x.testType);
        var result = strategy.CalculateResult(x.testResult);
    
        var test = new TestBuilder().ForUser(x.UserId).WithType(x.testType).WithResult(result).Build();

        _testservices.Create(test);

        return Ok(test);
    }

}