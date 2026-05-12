using UnityEngine;
using UnityEngine.UIElements;

public class JoinRoom : MonoBehaviour
{
    private Button _joinRoom;
    private Button _goBack;

    private void Awake()
    {
        var ui = GetComponent<UIDocument>().rootVisualElement;
        _joinRoom = ui.Q<Button>("btnJoin");
        _goBack = ui.Q<Button>("btnBack");
    }

    private void OnEnable()
    {
        _joinRoom.clicked += JoinRoomOnclicked;
        _goBack.clicked += GoBackOnclicked;
    }
    
    private void OnDisable()
    {
        _joinRoom.clicked -= JoinRoomOnclicked;
        _goBack.clicked -= GoBackOnclicked;
    }

    private void GoBackOnclicked()
    {
        EventBus.OnMenuChange(Menus.MainMenu);
    }

    private void JoinRoomOnclicked()
    {
        EventBus.OnMenuChange(Menus.JoinMenu);
    }
}
