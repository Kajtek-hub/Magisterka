using Backend.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

public class BioSignalDbContextFactory : IDesignTimeDbContextFactory<BioSignalDbContext>
{
    public BioSignalDbContext CreateDbContext(string[] args)
    {
        var options = new DbContextOptionsBuilder<BioSignalDbContext>()
            .UseSqlServer("Server=localhost;Database=MagisterkaBioDb;Trusted_Connection=True;TrustServerCertificate=True")
            .Options;
        return new BioSignalDbContext(options);
    }
}