using Fusion;
using Lib;
using UnityEngine;
using UnityEngine.UIElements;

public class LobbyMenu : NetworkBehaviour
{
    [Networked]
    [Capacity(3)]
    [UnitySerializeField]
    [OnChangedRender(nameof(RefreshMouses))]
    public NetworkDictionary<PlayerRef, PlayerRole> PlayersInfo => default;
    
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

    public override void Spawned()
    {
        base.Spawned();
        Debug.Log("Lobby menu was spawned!");
        RefreshMouses();
        RefreshRoomId();
    }

    private void OnEnable()
    {
        _joinTraffic.clicked += JoinTrafficOnclicked;
        _joinPolice.clicked += JoinPoliceOnclicked;
        _startGame.clicked += StartGameOnclicked;
        _closeRoom.clicked += CloseRoomOnclicked;
        _copyTxt.clicked += CopyTxtOnclicked;
        
        EventBus.PlayerJoined += EventBusOnPlayerJoined;
    }

    

    private void OnDisable()
    {
        _joinTraffic.clicked -= JoinTrafficOnclicked;
        _joinPolice.clicked -= JoinPoliceOnclicked;
        _startGame.clicked -= StartGameOnclicked;
        _closeRoom.clicked -= CloseRoomOnclicked;
        _copyTxt.clicked -= CopyTxtOnclicked;
        
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

    void RefreshMouses()
    {
        _trafficContainer.Clear();
        _policeContainer.Clear();
        _unassignedContainer.Clear();

        var idx = 0;
        foreach (var playerInfo in PlayersInfo)
        {
            var container = playerInfo.Value switch
            {
                PlayerRole.None => _unassignedContainer,
                PlayerRole.Police => _policeContainer,
                PlayerRole.Traffic => _trafficContainer,
                _ => null
            };
            var img = new Image
            {
                image = mouseImage,
                tintColor = ThemeManager.Instance.Current.playerColors[idx]
            };
            img.AddToClassList("mouseImage");
            container?.Add(img);
            idx++;
        }
    }
    
    private void EventBusOnPlayerJoined(PlayerRef _)
    {
        PlayersInfo.Set(Runner.LocalPlayer, PlayerRole.None);
        RefreshMouses();
    }

    private void RefreshRoomId()
    {
        _gameId.text = Runner.SessionInfo.Name;
    }

    private void StartGameOnclicked()
    {
        Debug.Log("Starting game (no hace nada xD)...");
    }

    private void JoinPoliceOnclicked()
    {
        Debug.Log("Player joins police!");
        PlayersInfo.Set(Runner.LocalPlayer, PlayerRole.Police);
        RefreshMouses();
    }

    private void JoinTrafficOnclicked()
    {
        Debug.Log("Player joins traffic!");
        PlayersInfo.Set(Runner.LocalPlayer, PlayerRole.Traffic);
        RefreshMouses();
    }
    
    private void CloseRoomOnclicked()
    {
        EventBus.OnMenuChange(Menus.MainMenu);
    }
}
