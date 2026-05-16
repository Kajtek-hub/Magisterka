/*using Backend.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

public class TestDbContextFactory : IDesignTimeDbContextFactory<TestDbContext>
{
    public TestDbContext CreateDbContext(string[] args)
    {
        var optionsBuilder = new DbContextOptionsBuilder<TestDbContext>();

        optionsBuilder.UseSqlServer(
            "Server=localhost;Database=MagisterkaTestDb;Trusted_Connection=True;TrustServerCertificate=True"
        );

        return new TestDbContext(optionsBuilder.Options);
    }
}*/