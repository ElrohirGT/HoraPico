using Fusion;
using UnityEngine;

public struct NetworkInputData : INetworkInput
{
    public const byte MouseButton0 = 1;
    public NetworkButtons Buttons;
    public Vector3 Direction;
}