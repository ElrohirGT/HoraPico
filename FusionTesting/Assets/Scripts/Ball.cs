using Fusion;
using UnityEngine;

public class Ball : NetworkBehaviour
{
    public float speed = 5f;
    public override void FixedUpdateNetwork()
    {
        base.FixedUpdateNetwork();
        if (Life.Expired(Runner))
        {
            Runner.Despawn(Object);
        }
        else
        {
            transform.position += speed * transform.forward * Runner.DeltaTime;
        }
    }
    
    [Networked] private TickTimer Life { get; set; }

    public void Init(float lifetimeSeconds)
    {
        Life = TickTimer.CreateFromSeconds(Runner, lifetimeSeconds);
    }
}
