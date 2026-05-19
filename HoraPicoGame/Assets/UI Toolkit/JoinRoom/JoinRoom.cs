using Fusion;
using UnityEngine;
using UnityEngine.UIElements;

public class JoinRoom : MonoBehaviour
{
    private TextField _txField;
    private Button _joinRoom;
    private Button _goBack;

    private void Awake()
    {
        var ui = GetComponent<UIDocument>().rootVisualElement;
        _joinRoom = ui.Q<Button>("btnJoin");
        _goBack = ui.Q<Button>("btnBack");
        _txField = ui.Q<TextField>("roomIdTextField");
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
        var roomId = _txField.value;
        EventBus.OnJoinOrHostGame(GameMode.AutoHostOrClient, roomId);
    }
}
