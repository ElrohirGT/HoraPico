using System;
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
        // _joinRoom.clicked
    }
}
