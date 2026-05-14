using System;

public static class EventBus
{
    public static event Action<Menus> MenuChange;

    public static void OnMenuChange(Menus obj)
    {
        MenuChange?.Invoke(obj);
    }

    public static event Action<Theme> ThemeChange;

    public static void OnThemeChange(Theme obj)
    {
        ThemeChange?.Invoke(obj);
    }

    public static event Action<int> ElixirChanged;

    public static void OnElixirChanged(int newElixirCount)
    {
        ElixirChanged?.Invoke(newElixirCount);
    }
}
