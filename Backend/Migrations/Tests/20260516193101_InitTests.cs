using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Backend.Migrations.Tests
{
    /// <inheritdoc />
    public partial class InitTests : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "GoNoGoTests",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Hits = table.Column<int>(type: "int", nullable: false),
                    Misses = table.Column<int>(type: "int", nullable: false),
                    FalseAlarms = table.Column<int>(type: "int", nullable: false),
                    CorrectRejections = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GoNoGoTests", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "KSSTests",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    SleepinessLevel = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KSSTests", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "NBackTests",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Hits = table.Column<int>(type: "int", nullable: false),
                    Misses = table.Column<int>(type: "int", nullable: false),
                    FalseAlarms = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NBackTests", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "PVTTests",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ReactionTime = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PVTTests", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "StroopTests",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Correct = table.Column<int>(type: "int", nullable: false),
                    Incorrect = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StroopTests", x => x.Id);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "GoNoGoTests");

            migrationBuilder.DropTable(
                name: "KSSTests");

            migrationBuilder.DropTable(
                name: "NBackTests");

            migrationBuilder.DropTable(
                name: "PVTTests");

            migrationBuilder.DropTable(
                name: "StroopTests");
        }
    }
}
