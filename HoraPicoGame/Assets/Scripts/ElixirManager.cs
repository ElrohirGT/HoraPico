using UnityEngine;

public class ElixirManager : MonoBehaviour
{
    [SerializeField] private int maxElixir = 10;
    public static ElixirManager Instance { get; private set; }

    public float secondsPerElixir = 1.5f;
    public int initialElixirCount;
    public int Count { get; private set; }
    public int MaxElixir => maxElixir;

    private float _remainingTillNextElixir;
    private bool _hasFired;
    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        Instance = this;

        // Optional: Keep the manager alive across scene changes
        DontDestroyOnLoad(gameObject);
    }

    private void Start()
    {
        _remainingTillNextElixir = secondsPerElixir;
        Count = initialElixirCount;
    }

    private void Update()
    {
        _remainingTillNextElixir -= Time.deltaTime;
        if (_remainingTillNextElixir > 0) return;
        if (Count + 1 > MaxElixir) return;

        Count += 1;
        EventBus.OnElixirChanged(Count);
        _remainingTillNextElixir = secondsPerElixir;
    }
}