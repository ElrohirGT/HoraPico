using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "Theme", menuName = "Scriptable Objects/Theme")]
public class Theme : ScriptableObject
{
    public Color neutralDark;
    public Color accentLight;
    public Color primary;
    public Color secondary;
    public Color accent;

    public List<Color> colorsWithoutNeutral;
}
