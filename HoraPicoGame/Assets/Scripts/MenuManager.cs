using System;
using System.Collections.Generic;
using UnityEngine;

public enum Menus
{
    MainMenu,
    JoinMenu,
    WaitingMenu,
}

public class MenuManager : MonoBehaviour
{
    [Serializable]
    private struct MenuItem
    {
        public Menus menuID;
        public GameObject obj;
    }
    [SerializeField] private List<MenuItem> menus;
    private readonly Dictionary<Menus, GameObject> _dict = new();

    private GameObject _active;

    private void Awake()
    {
        foreach (var menuItem in menus)
        {
            _dict.Add(menuItem.menuID, menuItem.obj);
            if (menuItem.menuID == Menus.MainMenu)
            {
                _active = menuItem.obj;
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
        _active.SetActive(false);
        if (_dict.TryGetValue(obj, out var item))
        {
            item.SetActive(true);
            _active = item;
        }
        else
        {
            Debug.LogError($"Failed to get menu: {obj}");
        }
    }
}
