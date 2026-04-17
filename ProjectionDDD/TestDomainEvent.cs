namespace Backend.TestDDD;
public abstract record DomainEvent;
public record TestSettledEvent(
    Guid UserId,
    string TestType,
    int Result,
    DateTime CreatedAt
) : DomainEvent;