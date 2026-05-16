namespace Backend.Services;
using Backend.Models;
using Backend.Data;

public class TestService : ITestService
{
    private readonly TestDbContext _context;

    public TestService(TestDbContext context)
    {
        _context = context;
    }

    public async Task<PVTTest> CreatePVTAsync(PVTTest test)
    {
        _context.PVTTests.Add(test);

        await _context.SaveChangesAsync();

        return test;
    }

    public async Task<GoNoGoTest> CreateGoNoGoAsync(GoNoGoTest test)
    {
        _context.GoNoGoTests.Add(test);

        await _context.SaveChangesAsync();

        return test;
    }

    public async Task<NBackTest> CreateNBackAsync(NBackTest test)
    {
        _context.NBackTests.Add(test);

        await _context.SaveChangesAsync();

        return test;
    }

    public async Task<StroopTest> CreateStroopAsync(StroopTest test)
    {
        _context.StroopTests.Add(test);

        await _context.SaveChangesAsync();

        return test;
    }

    public async Task<KSSTest> CreateKSSAsync(KSSTest test)
    {
        _context.KSSTests.Add(test);

        await _context.SaveChangesAsync();

        return test;
    }
}