using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;

public class MenuManager : MonoBehaviour
{
    [Serializable]
    private struct MenuItem
    {
        public Menus menuID;
        public UIDocument doc;
    }
    [SerializeField] private List<MenuItem> menus;
    private readonly Dictionary<Menus, UIDocument> _dict = new();

    private UIDocument _active;

    private void Awake()
    {
        foreach (var menuItem in menus)
        {
            _dict.Add(menuItem.menuID, menuItem.doc);
            if (menuItem.menuID == Menus.MainMenu)
            {
                _active = menuItem.doc;
            }
        }
    }

    private void OnEnable()
    {
        EventBus.MenuChange += EventBusOnMenuChange;
    }


    private void OnDisable()
    {
        EventBus.MenuChange -= EventBusOnMenuChange;
    }
    
    
    private void EventBusOnMenuChange(Menus obj)
    {
        _active.rootVisualElement.style.visibility = Visibility.Hidden;
        if (_dict.TryGetValue(obj, out var item))
        {
            _active = item;
            _active.rootVisualElement.style.visibility = Visibility.Visible;
        }
        else
        {
            Debug.LogError($"Failed to get menu: {obj}");
        }
    }
}
