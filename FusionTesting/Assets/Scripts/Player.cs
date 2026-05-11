using Fusion;

public class Player : NetworkBehaviour
{
    public float moveSpeed = 5f;

    private NetworkCharacterController _cc;

    private void Awake()
    {
        _cc = GetComponent<NetworkCharacterController>();
    }

    public override void FixedUpdateNetwork()
    {
        base.FixedUpdateNetwork();
        if (!GetInput(out NetworkInputData data)) return;
        
        data.Direction.Normalize();
        _cc.Move(moveSpeed * data.Direction * Runner.DeltaTime);
    }
}
