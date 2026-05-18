using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using Fusion;
using Fusion.Sockets;
using UnityEngine;
using UnityEngine.SceneManagement;

public enum PlayerRole
{
    None,
    Police,
    Traffic
}

public class PlayerInfo
{
    public string id;
    public PlayerRole role;
}

public class GameNetworkManager : MonoBehaviour, INetworkRunnerCallbacks
{
    [Networked] public List<PlayerInfo> PlayersInfo { get; private set; } = new();
    public static GameNetworkManager Instance { get; private set; }
    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
           Destroy(gameObject);
           return;
        }

        Instance = this;
        DontDestroyOnLoad(this);
    }

    private void OnEnable()
    {
        EventBus.JoinOrHostGame += EventBusOnJoinOrHostGame;
    }
    private void OnDisable()
    {
        EventBus.JoinOrHostGame -= EventBusOnJoinOrHostGame;
    }

    private void EventBusOnJoinOrHostGame(GameMode mode, string roomId)
    {
        StartCoroutine(JoinOrStartRoom(mode, roomId));
    }

    public NetworkRunner Runner { get; private set; }
    private IEnumerator JoinOrStartRoom(GameMode mode, string roomId)
    {
        Debug.Log("Display Load screen!");
        EventBus.OnLoadingStart();
        Runner = gameObject.AddComponent<NetworkRunner>();
        Runner.ProvideInput = true;
        yield return null;

        Debug.Log("Getting scene ref...");
        var scene = SceneRef.FromIndex(SceneManager.GetActiveScene().buildIndex);
        var sceneInfo = new NetworkSceneInfo();
        if (scene.IsValid)
        {
            sceneInfo.AddSceneRef(scene, LoadSceneMode.Additive);
        }

        var startGameTask = Runner.StartGame(new StartGameArgs()
        {
            GameMode = mode,
            SessionName = roomId,
            Scene = scene,
            SceneManager = gameObject.AddComponent<NetworkSceneManagerDefault>(),
        });
        StartCoroutine(LoadMenuProgress());
        
        Debug.Log("Waiting for connection to finish...");
        yield return Task.WhenAll(startGameTask);
        
        // EventBus.OnLoadingEnd();
        // EventBus.OnMenuChange(Menus.WaitingMenu);
    }

    private IEnumerator LoadMenuProgress()
    {
        const int seconds = 5;
        for (var i = 0; i <= seconds; i++)
        {
            yield return new WaitForSecondsRealtime(1);
            EventBus.OnLoadingProgress((float)(i+1) / seconds);
        }
    }

    public void OnObjectExitAOI(NetworkRunner runner, NetworkObject obj, PlayerRef player)
    {
        
    }

    public void OnObjectEnterAOI(NetworkRunner runner, NetworkObject obj, PlayerRef player)
    {
        
    }

    public void OnPlayerJoined(NetworkRunner runner, PlayerRef player)
    {
        PlayersInfo.Add(new PlayerInfo
        {
            id = player.ToString(),
            role = PlayerRole.None,
        });
        
        EventBus.OnLoadingEnd();
        EventBus.OnMenuChange(Menus.LobbyMenu);
        EventBus.OnPlayerJoined();
    }

    public void OnPlayerLeft(NetworkRunner runner, PlayerRef player)
    {
        
    }

    public void OnShutdown(NetworkRunner runner, ShutdownReason shutdownReason)
    {
        
    }

    public void OnDisconnectedFromServer(NetworkRunner runner, NetDisconnectReason reason)
    {
        
    }

    public void OnConnectRequest(NetworkRunner runner, NetworkRunnerCallbackArgs.ConnectRequest request, byte[] token)
    {
        
    }

    public void OnConnectFailed(NetworkRunner runner, NetAddress remoteAddress, NetConnectFailedReason reason)
    {
        
    }

    public void OnUserSimulationMessage(NetworkRunner runner, SimulationMessagePtr message)
    {
        
    }

    public void OnReliableDataReceived(NetworkRunner runner, PlayerRef player, ReliableKey key, ArraySegment<byte> data)
    {
        
    }

    public void OnReliableDataProgress(NetworkRunner runner, PlayerRef player, ReliableKey key, float progress)
    {
        
    }

    public void OnInput(NetworkRunner runner, NetworkInput input)
    {
        
    }

    public void OnInputMissing(NetworkRunner runner, PlayerRef player, NetworkInput input)
    {
        
    }

    public void OnConnectedToServer(NetworkRunner runner)
    {
        
    }

    public void OnSessionListUpdated(NetworkRunner runner, List<SessionInfo> sessionList)
    {
        
    }

    public void OnCustomAuthenticationResponse(NetworkRunner runner, Dictionary<string, object> data)
    {
        
        
    }

    public void OnHostMigration(NetworkRunner runner, HostMigrationToken hostMigrationToken)
    {
        
    }

    public void OnSceneLoadDone(NetworkRunner runner)
    {
        
    }

    public void OnSceneLoadStart(NetworkRunner runner)
    {
        
    }
}
