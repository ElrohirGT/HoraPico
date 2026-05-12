using System;
using UnityEngine;
using UnityEngine.UIElements;

public class WaitingMenu : MonoBehaviour
{
    private Button _joinTraffic;
    private Button _joinPolice;
    private Button _startGame;
    private Button _closeRoom;

    private void Awake()
    {
        var ui = GetComponent<UIDocument>().rootVisualElement;
        _joinPolice = ui.Q<Button>("btnJoinPolice");
        _joinTraffic = ui.Q<Button>("btnJoinTraffic");
        _startGame = ui.Q<Button>("btnStartGame");
        _closeRoom = ui.Q<Button>("btnCloseRoom");
    }

    private void OnEnable()
    {
        _joinTraffic.clicked += JoinTrafficOnclicked;
        _joinPolice.clicked += JoinPoliceOnclicked;
        _startGame.clicked += StartGameOnclicked;
        _closeRoom.clicked += CloseRoomOnclicked;
    }

    
    private void OnDisable()
    {
        _joinTraffic.clicked -= JoinTrafficOnclicked;
        _joinPolice.clicked -= JoinPoliceOnclicked;
        _startGame.clicked -= StartGameOnclicked;
        _closeRoom.clicked -= CloseRoomOnclicked;
    }

    private void StartGameOnclicked()
    {
        Debug.Log("Starting game (no hace nada xD)...");
    }

    private void JoinPoliceOnclicked()
    {
        Debug.Log("Joined police! (no hace nada)");
    }

    private void JoinTrafficOnclicked()
    {
        Debug.Log("Joined traffic! (no hace nada)");
    }
    
    private void CloseRoomOnclicked()
    {
        EventBus.OnMenuChange(Menus.MainMenu);
    }
}
