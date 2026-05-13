using UnityEngine;

public class PaintWithRandomColorFromTheme : MonoBehaviour
{
    [SerializeField] private Theme theme;
    [SerializeField] private MeshRenderer[] parts;

    private void Start()
    {
        var color = ThemeManager.Instance.GetRandomColorFromTheme();
        UpdateWithColor(color);
    }

    private void OnEnable()
    {
        EventBus.ThemeChange += EventBusOnThemeChange;
    }
    private void OnDisable()
    {
        EventBus.ThemeChange -= EventBusOnThemeChange;
    }

    private void EventBusOnThemeChange(Theme obj)
    {
        var color = ThemeManager.Instance.GetRandomColorFromTheme();
        UpdateWithColor(color);
    }

    private void UpdateWithColor(Color color)
    {
        foreach (var meshRenderer in parts)
        {
            meshRenderer.material.color = color;
        }
    }
}
