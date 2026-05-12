using UnityEngine;
using UnityEngine.UIElements;

public class HideUIOnWake : MonoBehaviour
{
    private void Awake()
    {
        GetComponent<UIDocument>().rootVisualElement.style.visibility = Visibility.Hidden;
    }
}
