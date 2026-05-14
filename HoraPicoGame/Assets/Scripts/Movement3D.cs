using UnityEngine;
using UnityEngine.InputSystem;

public class Movement3D : MonoBehaviour
{
    public float speed = 10f;
    private InputAction _move;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        _move = InputSystem.actions.FindAction("Move");
    }

    // Update is called once per frame
    void Update()
    {
        var movement = _move.ReadValue<Vector2>();
        var vec3Movement = new Vector3(movement.x, 0, movement.y);
        transform.position += speed * Time.deltaTime * vec3Movement;
    }
}
