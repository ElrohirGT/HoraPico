using System;
using System.Text;
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
        
        EventBus.MenuChange += EventBusOnMenuChange;
    }


    private void OnDisable()
    {
        _joinTraffic.clicked -= JoinTrafficOnclicked;
        _joinPolice.clicked -= JoinPoliceOnclicked;
        _startGame.clicked -= StartGameOnclicked;
        _closeRoom.clicked -= CloseRoomOnclicked;
        
        EventBus.MenuChange -= EventBusOnMenuChange;
    }

    private string RandomString(string alphabet, int length)
    {
        var str = new StringBuilder(new string('?', length));
        for (var i = 0; i < length; i++)
        {
            str[i] = alphabet[Random.Range(0, alphabet.Length)];
        }
        return str.ToString();
    }

    private string GenerateID()
    {
        const int charsPerSection = 4;
        const int sections = 3;
        const string alphabet = "abcdefghijklmnopqrstuvwxyz0123456789";

        var roomId = new StringBuilder();

        for (var i = 0; i < sections; i++)
        {
            var str = RandomString(alphabet, charsPerSection);
            roomId.Append(str);

            if (i + 1 < sections)
            {
                roomId.Append('-');
            }
        }

        return roomId.ToString();
    }
    
    private void EventBusOnMenuChange(Menus obj)
    {
        if (obj != Menus.WaitingMenu) return;
        var id = GenerateID();
        _gameId.text = id;
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
