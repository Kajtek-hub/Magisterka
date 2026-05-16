using Backend.Data;
using Backend.DTO;
using Backend.Models;
using Microsoft.EntityFrameworkCore;

namespace Backend.Services;

public class TestService : ITestService
{
    private readonly TestDbContext _context;

    public TestService(TestDbContext context)
    {
        _context = context;
    }

    

    public async Task<TestResultDTO> CreatePVTAsync(PVTTestDTO dto)
    {
        var test = new PVTTest
        {
            UserId = dto.UserId,
            ReactionTime = dto.ReactionTime
        };
        _context.PVTTests.Add(test);
        await _context.SaveChangesAsync();
        return ToDTO(test, "PVT", new() {
            ["reactionTime"] = test.ReactionTime
        });
    }

    public async Task<TestResultDTO> CreateGoNoGoAsync(GoNoGoTestDTO dto)
    {
        var test = new GoNoGoTest
        {
            UserId = dto.UserId,
            Hits = dto.Hits,
            Misses = dto.Misses,
            FalseAlarms = dto.FalseAlarms,
            CorrectRejections = dto.CorrectRejections
        };
        _context.GoNoGoTests.Add(test);
        await _context.SaveChangesAsync();
        return ToDTO(test, "GoNoGo", new() {
            ["hits"] = test.Hits,
            ["misses"] = test.Misses,
            ["falseAlarms"] = test.FalseAlarms,
            ["correctRejections"] = test.CorrectRejections
        });
    }

    public async Task<TestResultDTO> CreateNBackAsync(NBackTestDTO dto)
    {
        var test = new NBackTest
        {
            UserId = dto.UserId,
            Hits = dto.Hits,
            Misses = dto.Misses,
            FalseAlarms = dto.FalseAlarms
        };
        _context.NBackTests.Add(test);
        await _context.SaveChangesAsync();
        return ToDTO(test, "NBack", new() {
            ["hits"] = test.Hits,
            ["misses"] = test.Misses,
            ["falseAlarms"] = test.FalseAlarms
        });
    }

    public async Task<TestResultDTO> CreateStroopAsync(StroopTestDTO dto)
    {
        var test = new StroopTest
        {
            UserId = dto.UserId,
            Correct = dto.Correct,
            Incorrect = dto.Incorrect
        };
        _context.StroopTests.Add(test);
        await _context.SaveChangesAsync();
        return ToDTO(test, "Stroop", new() {
            ["correct"] = test.Correct,
            ["incorrect"] = test.Incorrect
        });
    }

    public async Task<TestResultDTO> CreateKSSAsync(KSSTestDTO dto)
    {
        var test = new KSSTest
        {
            UserId = dto.UserId,
            SleepinessLevel = dto.SleepinessLevel
        };
        _context.KSSTests.Add(test);
        await _context.SaveChangesAsync();
        return ToDTO(test, "KSS", new() {
            ["sleepinessLevel"] = test.SleepinessLevel
        });
    }

    

    public async Task<List<TestResultDTO>> GetPVTByUserAsync(Guid userId)
    {
        var tests = await _context.PVTTests
            .Where(t => t.UserId == userId)
            .OrderByDescending(t => t.CreatedAt)
            .ToListAsync();

        return tests.Select(t => ToDTO(t, "PVT", new() {
            ["reactionTime"] = t.ReactionTime
        })).ToList();
    }

    public async Task<List<TestResultDTO>> GetGoNoGoByUserAsync(Guid userId)
    {
        var tests = await _context.GoNoGoTests
            .Where(t => t.UserId == userId)
            .OrderByDescending(t => t.CreatedAt)
            .ToListAsync();

        return tests.Select(t => ToDTO(t, "GoNoGo", new() {
            ["hits"] = t.Hits,
            ["misses"] = t.Misses,
            ["falseAlarms"] = t.FalseAlarms,
            ["correctRejections"] = t.CorrectRejections
        })).ToList();
    }

    public async Task<List<TestResultDTO>> GetNBackByUserAsync(Guid userId)
    {
        var tests = await _context.NBackTests
            .Where(t => t.UserId == userId)
            .OrderByDescending(t => t.CreatedAt)
            .ToListAsync();

        return tests.Select(t => ToDTO(t, "NBack", new() {
            ["hits"] = t.Hits,
            ["misses"] = t.Misses,
            ["falseAlarms"] = t.FalseAlarms
        })).ToList();
    }

    public async Task<List<TestResultDTO>> GetStroopByUserAsync(Guid userId)
    {
        var tests = await _context.StroopTests
            .Where(t => t.UserId == userId)
            .OrderByDescending(t => t.CreatedAt)
            .ToListAsync();

        return tests.Select(t => ToDTO(t, "Stroop", new() {
            ["correct"] = t.Correct,
            ["incorrect"] = t.Incorrect
        })).ToList();
    }

    public async Task<List<TestResultDTO>> GetKSSByUserAsync(Guid userId)
    {
        var tests = await _context.KSSTests
            .Where(t => t.UserId == userId)
            .OrderByDescending(t => t.CreatedAt)
            .ToListAsync();

        return tests.Select(t => ToDTO(t, "KSS", new() {
            ["sleepinessLevel"] = t.SleepinessLevel
        })).ToList();
    }

    

    private static TestResultDTO ToDTO(Test test, string type, Dictionary<string, int> results)
    {
        return new TestResultDTO
        {
            Id = test.Id,
            UserId = test.UserId,
            CreatedAt = test.CreatedAt,
            TestType = type,
            Results = results
        };
    }
}