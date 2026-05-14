using UnityEngine;
using UnityEngine.UIElements;

public class PoliceHUD : MonoBehaviour
{
    private ProgressBar _bar;
    private Label _display;
    
    private void Awake()
    {
        var ui = GetComponent<UIDocument>().rootVisualElement;
        _bar = ui.Q<ProgressBar>("elixirBar");
        _display = ui.Q<Label>("elixirCount");
    }

    private void Start()
    {
        _bar.highValue = ElixirManager.Instance.MaxElixir;
        _bar.value = 0;
        _display.text = " 0";
    }

    private void OnEnable()
    {
        EventBus.ElixirChanged += EventBusOnElixirChanged;
    }
    private void OnDisable()
    {
        EventBus.ElixirChanged -= EventBusOnElixirChanged;
    }

    private void EventBusOnElixirChanged(int obj)
    {
        _bar.value = obj;
        _display.text = $"{obj,2}";
    }
}
