using Backend.Models;
using Microsoft.EntityFrameworkCore;

namespace Backend.Data;

public class BioSignalDbContext : DbContext
{
    public BioSignalDbContext(DbContextOptions<BioSignalDbContext> options)
        : base(options) { }

    public DbSet<BioSignalRecording> Recordings => Set<BioSignalRecording>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // BLOB może być duży — wyłącz eager loading
        modelBuilder.Entity<BioSignalRecording>()
            .Property(r => r.FileData)
            .IsRequired();
    }
}