
using Backend.DTO;
using Backend.Models;

namespace Backend.Validation;

public class ValidationResult
{
    public bool IsValid {get; set;}
    public List<string> Erros {get; set;} = new List<string>();

    private ValidationResult() {} //żebyśmy nie mogli utworzyć instancji takiej klasy

    public static ValidationResult Success() => new() {IsValid = true};
    public static ValidationResult Failure(params string[] errors) => new ValidationResult {IsValid = false, Erros = errors.ToList()};
}


public interface IValidator<T>
{
    ValidationResult Validate(T input);
}

public class TestValidator : IValidator<AddTestDTO>
{
    public ValidationResult Validate(AddTestDTO input)
    {
        if(input.testType is PVTTest)
        {
            if(input.testResult <= 0)
            {
                 return ValidationResult.Failure("PVT result must be greater than 0");

            }
        }

        if(input.testType is KSSTest)
        {
            if(input.testResult <1 || input.testResult > 9)
            {
                return ValidationResult.Failure("KSS must be between 1 and 9");
            }
        }


        return ValidationResult.Success();
    }
}