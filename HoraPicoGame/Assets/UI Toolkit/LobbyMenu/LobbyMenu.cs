using System;
using Fusion;
using UnityEngine;
using UnityEngine.UIElements;

public class LobbyMenu : MonoBehaviour
{
    public Texture2D mouseImage;
    
    private Button _joinTraffic;
    private Button _joinPolice;
    private Button _startGame;
    private Button _closeRoom;
    
    private Button _copyTxt;

    private Label _gameId;
    private int _assignedPlayerCount;

    private VisualElement _unassignedContainer;
    private VisualElement _trafficContainer;
    private VisualElement _policeContainer;

    private void Awake()
    {
        var ui = GetComponent<UIDocument>().rootVisualElement;
        _joinPolice = ui.Q<Button>("btnJoinPolice");
        _joinTraffic = ui.Q<Button>("btnJoinTraffic");
        _startGame = ui.Q<Button>("btnStartGame");
        _closeRoom = ui.Q<Button>("btnCloseRoom");
        _copyTxt = ui.Q<Button>("copyTextBtn");
        _gameId = ui.Q<Label>("roomId");

        _unassignedContainer = ui.Q<VisualElement>("unassignedContainer");
        _trafficContainer = ui.Q<VisualElement>("trafficContainer");
        _policeContainer = ui.Q<VisualElement>("policeContainer");
        
        _startGame.SetEnabled(false);
    }

    private void Start()
    {
        RefreshUI();
    }

    private void OnEnable()
    {
        _joinTraffic.clicked += JoinTrafficOnclicked;
        _joinPolice.clicked += JoinPoliceOnclicked;
        _startGame.clicked += StartGameOnclicked;
        _closeRoom.clicked += CloseRoomOnclicked;
        _copyTxt.clicked += CopyTxtOnclicked;
        
        EventBus.JoinOrHostGame += EventBusOnJoinOrHostGame;
        EventBus.PlayerJoined += EventBusOnPlayerJoined;
    }

    

    private void OnDisable()
    {
        _joinTraffic.clicked -= JoinTrafficOnclicked;
        _joinPolice.clicked -= JoinPoliceOnclicked;
        _startGame.clicked -= StartGameOnclicked;
        _closeRoom.clicked -= CloseRoomOnclicked;
        _copyTxt.clicked -= CopyTxtOnclicked;
        
        EventBus.JoinOrHostGame -= EventBusOnJoinOrHostGame;
        EventBus.PlayerJoined -= EventBusOnPlayerJoined;
    }
    
    private void CopyTxtOnclicked()
    {
        GUIUtility.systemCopyBuffer = _gameId.text;
        EventBus.OnNotification("Copied!", "Room ID copied to clipboard.", 3f);
    }

    private void Update()
    {
        if (GameNetworkManager.Instance.Runner?.IsServer ?? false)
        {
            _startGame.SetEnabled(_assignedPlayerCount == 3);  
        }
    }

    void RefreshUI()
    {
        _trafficContainer.Clear();
        _policeContainer.Clear();
        _unassignedContainer.Clear();
        
        for (var i = 0; i < GameNetworkManager.Instance.PlayersInfo.Count; i++)
        {
            var current = GameNetworkManager.Instance.PlayersInfo[i];
            VisualElement container = current.role switch
            {
                PlayerRole.None => _unassignedContainer,
                PlayerRole.Police => _policeContainer,
                PlayerRole.Traffic => _trafficContainer,
                _ => null
            };

            var img = new Image
            {
                image = mouseImage,
                tintColor = ThemeManager.Instance.Current.playerColors[i]
            };
            img.AddToClassList("mouseImage");
            container?.Add(img);
        }
    }
    
    private void EventBusOnPlayerJoined()
    {
        RefreshUI();
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
