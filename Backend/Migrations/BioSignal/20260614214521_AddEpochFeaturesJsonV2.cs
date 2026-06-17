using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Backend.Migrations.BioSignal
{
    /// <inheritdoc />
    public partial class AddEpochFeaturesJsonV2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "EpochFeaturesJson",
                table: "Recordings",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "EpochFeaturesJson",
                table: "Recordings");
        }
    }
}
