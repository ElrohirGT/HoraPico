using Fusion;
using UnityEngine;

public class Player : NetworkBehaviour
{
    public float moveSpeed = 5f;
    public float bulletLifeSecs = 3f;
    public float shootCooldownSecs = 1f;

    [SerializeField] private Ball bulletPrefab;
    [Networked] private TickTimer CooldownTimer { get; set; }
    
    // Change color when bullet spawns.
    [Networked] private bool SpawnedProjectile { get; set; }
    private ChangeDetector _changeDetector;
    public override void Spawned()
    {
        base.Spawned();
        _changeDetector = GetChangeDetector(ChangeDetector.Source.SimulationState);
    }

    private Material _material;
    private Color _originalColor;
    private NetworkCharacterController _cc;
    private void Awake()
    {
        _cc = GetComponent<NetworkCharacterController>();
        _material = GetComponentInChildren<MeshRenderer>().material;
        _originalColor = _material.color;
    }

    public override void Render()
    {
        base.Render();
        foreach (var change in _changeDetector.DetectChanges(this))
        {
            _material.color = change switch
            {
                nameof(SpawnedProjectile) => Color.white,
                _ => _material.color
            };
        }

        _material.color = Color.Lerp(_material.color, _originalColor, Time.deltaTime);
    }

    private Vector3 _lastDir = Vector3.forward;
    public override void FixedUpdateNetwork()
    {
        base.FixedUpdateNetwork();
        if (!GetInput(out NetworkInputData data)) return;
        
        data.Direction.Normalize();
        _cc.Move(moveSpeed * data.Direction * Runner.DeltaTime);

        if (HasStateAuthority && CooldownTimer.ExpiredOrNotRunning(Runner) && data.Buttons.IsSet(NetworkInputData.MouseButton0))
        {
            CooldownTimer = TickTimer.CreateFromSeconds(Runner, shootCooldownSecs);
            Runner.Spawn(
                bulletPrefab,
                transform.position + _lastDir,
                Quaternion.LookRotation(_lastDir),
                Object.InputAuthority,
                ((runner, o) => o.GetComponent<Ball>().Init(bulletLifeSecs))
            );
            SpawnedProjectile = !SpawnedProjectile;
        }
        
        _lastDir = data.Direction;
    }
}
