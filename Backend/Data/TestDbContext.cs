using Backend.Models;
using Microsoft.EntityFrameworkCore;

namespace Backend.Data;

public class TestDbContext : DbContext
{
    public TestDbContext(DbContextOptions<TestDbContext> options)
        : base(options)
    {
    }

    public DbSet<PVTTest> PVTTests => Set<PVTTest>();

    public DbSet<GoNoGoTest> GoNoGoTests => Set<GoNoGoTest>();

    public DbSet<NBackTest> NBackTests => Set<NBackTest>();

    public DbSet<StroopTest> StroopTests => Set<StroopTest>();

    public DbSet<KSSTest> KSSTests => Set<KSSTest>();
}
