namespace Backend.TestDDD;
public class TestProjectionHandler
{
    private readonly TestProjectionStore _store;

    public TestProjectionHandler(TestProjectionStore store)
    {
        _store = store;
    }

    public void Handle(TestSettledEvent e)
    {
        var projection = _store.Get(e.UserId)
            ?? TestStatsProjection.CreateEmpty(e.UserId);

        projection.Apply(e);

        _store.Save(e.UserId, projection);
    }
}