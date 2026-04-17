namespace Backend.TestDDD;
public class TestProjectionStore
{
    private readonly Dictionary<Guid, TestStatsProjection> _data = new();

    public TestStatsProjection? Get(Guid userId)
    {
        return _data.TryGetValue(userId, out var value) ? value : null;
    }

    public void Save(Guid userId, TestStatsProjection projection)
    {
        _data[userId] = projection;
    }
}