using System;

public static class EventBus
{
    public static event Action<Menus> MenuChange;

    public static void OnMenuChange(Menus obj)
    {
        MenuChange?.Invoke(obj);
    }
}
