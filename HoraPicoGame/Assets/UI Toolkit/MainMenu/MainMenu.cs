using Fusion;
using Lib;
using UnityEngine;
using UnityEngine.UIElements;

public class MainMenu : MonoBehaviour
{
    private Button _host;
    private Button _join;
    private Button _quit;

    private UIDocument _ui;
    
    private void Awake()
    {
        _ui = GetComponent<UIDocument>();
        var ui = _ui.rootVisualElement;
        _host = ui.Q<Button>("hostBtn");
        _join = ui.Q<Button>("joinBtn");
        _quit = ui.Q<Button>("quitBtn");
    }

    private void OnEnable()
    {
        _host.clicked += HostOnclicked;
        _join.clicked += JoinOnclicked;
        _quit.clicked += QuitOnclicked;
    }
    
    private void OnDisable()
    {
        _host.clicked -= HostOnclicked;
        _join.clicked -= JoinOnclicked;
        _quit.clicked -= QuitOnclicked;
    }

    private static void QuitOnclicked()
    {
        Application.Quit();
    }

    private void JoinOnclicked()
    {
        EventBus.OnMenuChange(Menus.JoinMenu);
    }

    private void HostOnclicked()
    {
        var roomId = RoomUtils.GenerateID();
        Debug.Log($"Trying to host room: {roomId}");
        EventBus.OnJoinOrHostGame(GameMode.AutoHostOrClient, roomId);
    }
}
