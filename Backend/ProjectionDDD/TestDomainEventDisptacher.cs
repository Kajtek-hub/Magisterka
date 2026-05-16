/*
namespace Backend.TestDDD;
public class TestDomainEventDispatcher
{
    private readonly Dictionary<Type, List<Action<DomainEvent>>> _handlers = new Dictionary<Type, List<Action<DomainEvent>>>();
    
    public void Subscribe<TEvent>(Action<TEvent> handler ) where TEvent: DomainEvent
    {
        var eventType = typeof(TEvent);
        if (!_handlers.ContainsKey(eventType))
        {
            _handlers[eventType] = new List<Action<DomainEvent>>();
        }
        _handlers[eventType].Add(e => handler((TEvent)e));
    }

    public void Publish(DomainEvent @event)
    {
        var eventType = @event.GetType();
        if (_handlers.ContainsKey(eventType))
        {
            foreach (var handler in _handlers[eventType])
            {
                handler(@event);
            }
        }
    }
}
*/