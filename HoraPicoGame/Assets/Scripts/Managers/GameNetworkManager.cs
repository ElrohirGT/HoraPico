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

public class GameNetworkManager : MonoBehaviour, INetworkRunnerCallbacks
{
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

    public string LobbyId { get; private set; }

    private void OnEnable()
    {
        EventBus.JoinOrHostGame += EventBusOnJoinOrHostGame;
        EventBus.QuitRoom += EventBusOnQuitRoom;
    }


    private void OnDisable()
    {
        EventBus.JoinOrHostGame -= EventBusOnJoinOrHostGame;
        EventBus.QuitRoom -= EventBusOnQuitRoom;
    }

    private void EventBusOnQuitRoom()
    {
        Runner.Shutdown(false);
    }

    private void EventBusOnJoinOrHostGame(GameMode mode, string roomId)
    {
        StartCoroutine(JoinOrStartRoom(mode, roomId));
    }

    public NetworkRunner Runner { get; private set; }

    private IEnumerator JoinOrStartRoom(GameMode mode, string roomId)
    {
        LobbyId = roomId;
        Debug.Log("Display Load screen!");
        EventBus.OnLoadingStart();
        Runner = gameObject.AddComponent<NetworkRunner>();
        Runner.ProvideInput = true;
        yield return null;

        Debug.Log("Getting scene ref...");
        var scene = SceneRef.FromIndex(1);
        var networkSceneInfo = new NetworkSceneInfo();
        if (scene.IsValid)
        {
            networkSceneInfo.AddSceneRef(scene, activeOnLoad: true);
        }

        Debug.Log("Waiting for connection to finish...");
        StartCoroutine(LoadMenuProgress());
        var task = Runner.StartGame(new StartGameArgs()
        {
            GameMode = mode,
            SessionName = roomId,
            Scene = scene,
            SceneManager = gameObject.AddComponent<NetworkSceneManagerDefault>(),
            IsOpen = true,
        });
        yield return task;

        while (!task.IsCompleted)
        {
            yield return null;
        }

        EventBus.OnLoadingEnd();
    }

    private IEnumerator LoadMenuProgress()
    {
        const int seconds = 5;
        for (var i = 0; i <= seconds; i++)
        {
            yield return new WaitForSecondsRealtime(1);
            EventBus.OnLoadingProgress((float)(i + 1) / seconds);
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
        EventBus.OnNotification("Player Joined!", $"The player {player} has joined!", 3f);
        EventBus.OnPlayerJoined(player);
    }

    public void OnPlayerLeft(NetworkRunner runner, PlayerRef player)
    {
        EventBus.OnNotification("Player Left!", $"The player {player} has left!", 3f);
    }

    public void OnShutdown(NetworkRunner runner, ShutdownReason shutdownReason)
    {
        SceneManager.LoadScene("MainMenu");
        Debug.Log("Destroying runner...");
        Destroy(Runner);
    }

    public void OnDisconnectedFromServer(NetworkRunner runner, NetDisconnectReason reason)
    {
        SceneManager.LoadScene("MainMenu");
        EventBus.OnNotification("Disconnected!", $"Lost connection to the server: {reason}", 3f);
        Destroy(Runner);
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