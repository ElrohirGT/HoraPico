using System;
using UnityEngine;
using Random = UnityEngine.Random;

public class ThemeManager : MonoBehaviour
{
    [SerializeField] private Theme initialTheme;

    // Static reference that can be accessed from any script
    public static ThemeManager Instance { get; private set; }
    
    public Theme Current { get; private set; }

    private void Awake()
    {
        // Enforce the singleton pattern: destroy duplicates
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        Instance = this;
        
        // Optional: Keep the manager alive across scene changes
        DontDestroyOnLoad(gameObject);
        ChangeTheme(initialTheme);
    }

    public void ChangeTheme(Theme newTheme)
    {
        Instance.Current = newTheme;
        EventBus.OnThemeChange(newTheme);
    }

    public Color GetRandomColorFromTheme()
    {
        var colors = Instance.Current.colorsWithoutNeutral;
        return colors[Random.Range(0, colors.Count)];
    }
    
}
