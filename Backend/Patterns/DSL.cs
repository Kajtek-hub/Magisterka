/*
namespace Backend.Patterns;
public class RuleEngine<T>
{
    private readonly List<(Func<T, bool> condition, Action<T> action)> _rules = new();

    public RuleEngine<T> IF(Func<T, bool> condtion)
    {
        _rules.Add((condtion, _ => {}));
        return this;
    }

    public RuleEngine<T> THEN(Action<T> action)
    {
        var last = _rules.Last();
        _rules[_rules.Count - 1] = (last.condition, action);
        return this;
    }

    public T EXECUTE(T input)
    {
        foreach (var (condition, action) in _rules)
        {
            if (condition(input))
            {
                action(input);
            }
        }
        return input;
    }
}*/