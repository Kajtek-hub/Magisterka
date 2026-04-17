using Backend.Services;
using Backend.TestDDD;
using System.Text.Json.Serialization;
var builder = WebApplication.CreateBuilder(args);

//builder.Services.AddOpenApi();
builder.Services.AddControllers().AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.Converters.Add(
            new JsonStringEnumConverter()
        );
    });

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddSingleton<IUserService, UserService>();
builder.Services.AddSingleton<ITestService, TestService>();

builder.Services.AddSingleton<TestProjectionStore>();
builder.Services.AddSingleton<TestDomainEventDispatcher>();
builder.Services.AddSingleton<TestProjectionHandler>();


builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutter", policy =>
    {
        policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
    }
    );
});

var app = builder.Build();
var dispatcher = app.Services.GetRequiredService<TestDomainEventDispatcher>();
var handler = app.Services.GetRequiredService<TestProjectionHandler>();

dispatcher.Subscribe<TestSettledEvent>(handler.Handle);

app.UseSwagger();
app.UseSwaggerUI();


app.UseHttpsRedirection();

app.MapControllers();
app.UseCors("AllowFlutter");

app.Run();
