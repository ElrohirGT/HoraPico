using System;
using System.Text;
using Fusion;
using UnityEngine;
using UnityEngine.UIElements;
using Random = UnityEngine.Random;

public class WaitingMenu : MonoBehaviour
{
    private Button _joinTraffic;
    private Button _joinPolice;
    private Button _startGame;
    private Button _closeRoom;

    private Label _gameId;

    private void Awake()
    {
        var ui = GetComponent<UIDocument>().rootVisualElement;
        _joinPolice = ui.Q<Button>("btnJoinPolice");
        _joinTraffic = ui.Q<Button>("btnJoinTraffic");
        _startGame = ui.Q<Button>("btnStartGame");
        _closeRoom = ui.Q<Button>("btnCloseRoom");
        _gameId = ui.Q<Label>("roomId");
    }

    private void OnEnable()
    {
        _joinTraffic.clicked += JoinTrafficOnclicked;
        _joinPolice.clicked += JoinPoliceOnclicked;
        _startGame.clicked += StartGameOnclicked;
        _closeRoom.clicked += CloseRoomOnclicked;
        
        EventBus.JoinOrHostGame += EventBusOnJoinOrHostGame;
    }

    private void OnDisable()
    {
        _joinTraffic.clicked -= JoinTrafficOnclicked;
        _joinPolice.clicked -= JoinPoliceOnclicked;
        _startGame.clicked -= StartGameOnclicked;
        _closeRoom.clicked -= CloseRoomOnclicked;
        
        EventBus.JoinOrHostGame -= EventBusOnJoinOrHostGame;
    }

    private void EventBusOnJoinOrHostGame(GameMode _, string roomId)
    {
        _gameId.text = roomId;
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
