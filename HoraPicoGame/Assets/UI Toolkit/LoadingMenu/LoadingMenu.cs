using System;
using System.Collections.Generic;
using Lib;
using UnityEngine;
using UnityEngine.UIElements;

public class LoadingMenu : MonoBehaviour
{
    [SerializeField] private List<string> tips;

    private VisualElement _root;
    private ProgressBar _progressBar;
    private Label _tipLabel;

    private void Awake()
    {
        _root = GetComponent<UIDocument>().rootVisualElement;
        _progressBar = _root.Q<ProgressBar>("progress");
        _tipLabel = _root.Q<Label>("tipLabel");
        
    }

    private void OnEnable()
    {
        EventBus.LoadingStart += EventBusOnLoadingStart;
        EventBus.LoadingProgress += EventBusOnLoadingProgress;
        EventBus.LoadingEnd += EventBusOnLoadingEnd;
    }
    
    private void OnDisable()
    {
        EventBus.LoadingStart -= EventBusOnLoadingStart;
        EventBus.LoadingProgress -= EventBusOnLoadingProgress;
        EventBus.LoadingEnd -= EventBusOnLoadingEnd;
    }

    private void EventBusOnLoadingEnd()
    {
        Debug.Log("End loading screen...");
        _root.style.visibility = Visibility.Hidden;
    }

    private void EventBusOnLoadingProgress(float obj)
    {
        Debug.Log("Received progress! " + obj);
        _progressBar.value = obj;
    }

    
    private void EventBusOnLoadingStart()
    {
        Debug.Log("Starting Loading screen...");
        _root.style.visibility = Visibility.Visible;
        _progressBar.value = 0;
        _tipLabel.text = RandomUtils.RandomFromList(tips);
    }
}
