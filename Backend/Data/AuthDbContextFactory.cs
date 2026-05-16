/*using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

public class AuthDbContextFactory : IDesignTimeDbContextFactory<AuthDbContext>
{
    public AuthDbContext CreateDbContext(string[] args)
    {
        var optionsBuilder = new DbContextOptionsBuilder<AuthDbContext>();

        optionsBuilder.UseSqlServer(
            "Server=localhost;Database=MagisterkaAuthDb;Trusted_Connection=True;TrustServerCertificate=True"
        );

        return new AuthDbContext(optionsBuilder.Options);
    }
}*/