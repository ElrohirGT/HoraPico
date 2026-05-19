using System;
using Fusion;

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


    public static event Action LoadingStart;

    public static void OnLoadingStart()
    {
        LoadingStart?.Invoke();
    }
    
    public static event Action<float> LoadingProgress;

    /// <summary>
    /// Triggers the event LoadingProgress.
    /// The progress is a float between 0-1.
    /// </summary>
    /// <param name="progress">The current loading progress. Between 0-1.</param>
    public static void OnLoadingProgress(float progress)
    {
        LoadingProgress?.Invoke(progress);
    }

    public static event Action LoadingEnd;

    public static void OnLoadingEnd()
    {
        LoadingEnd?.Invoke();
    }

    public static event Action<GameMode, string> JoinOrHostGame;
    public static void OnJoinOrHostGame(GameMode mode, string roomId)
    {
        JoinOrHostGame?.Invoke(mode, roomId);
    }

    public static event Action<PlayerRef> PlayerJoined;
    public static void OnPlayerJoined(PlayerRef refr)
    {
        PlayerJoined?.Invoke(refr);
    }

    public static event Action<string, string, float> Notification;

    public static void OnNotification(string title, string content, float secDuration)
    {
        Notification?.Invoke(title, content, secDuration);
    }
    
    public static event Action QuitRoom;

    public static void OnQuitRoom()
    {
        QuitRoom?.Invoke();
    }
}
