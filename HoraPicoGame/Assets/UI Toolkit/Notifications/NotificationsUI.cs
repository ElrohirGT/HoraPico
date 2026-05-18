using Lib;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UIElements;

public class Notifications : MonoBehaviour
{
    public VisualTreeAsset notificationTemplate;

    private VisualElement _root;
    private VisualElement _container;
    private int _notifCount;
    private void Awake()
    {
        _root = GetComponent<UIDocument>().rootVisualElement;
        _container = _root.Q<VisualElement>("notificationContainer");

    }

    private void OnEnable()
    {
        EventBus.Notification += EventBusOnNotification;
    }
    
    private void OnDisable()
    {
        EventBus.Notification -= EventBusOnNotification;
    }

    private void EventBusOnNotification(string title, string content, float secDuration)
    {
        _root.style.display = DisplayStyle.Flex;
        _notifCount++;
        var tree = notificationTemplate.Instantiate();
        tree.Q<Label>("title").text = title;
        tree.Q<Label>("content").text = content;
        
        var timer = gameObject.AddComponent<CooldownTimer>();
        timer.originalSecs = secDuration;
        timer.done += () =>
        {
            _container.Remove(tree);
            _notifCount--;
            if (_notifCount <= 0)
            {
                Debug.Log($"Disabling notif: {title}");
                // _root.style.visibility = Visibility.Hidden;
                _root.style.display = DisplayStyle.None;
            }
            Destroy(timer);
        };
        timer.Restart();
        
        _container.Add(tree);
    }
}
