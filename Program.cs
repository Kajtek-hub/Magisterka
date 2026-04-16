using Backend.Services;


var builder = WebApplication.CreateBuilder(args);

// 🔹 Services
builder.Services.AddScoped<UserService>();
builder.Services.AddScoped<TestService>();

builder.Services.AddControllers();

// 🔹 Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// 🔹 Middleware
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// 🔹 Routing
app.MapControllers();

// 🔹 Test endpoint
app.MapGet("/", () => "Hello API");

app.Run();