using System.Collections;
using UnityEngine;

public class TrafficLight : MonoBehaviour
{
    public enum TrafficLightState { Red, Green, Hacked }

    [SerializeField] private TrafficLightState currentState = TrafficLightState.Red;

    [Header("Configuración de Tiempos")]
    [SerializeField] private float greenDuration = 5f;
    [SerializeField] private float redDuration = 5f;

    private Coroutine sequenceCoroutine;

    void Start()
    {
        sequenceCoroutine = StartCoroutine(TrafficLightSequence());
    }

    IEnumerator TrafficLightSequence()
    {

        while (currentState != TrafficLightState.Hacked)
        {
            switch (currentState)
            {
                case TrafficLightState.Red:
                    SetVisuals(Color.red, "Red");

                    GetComponent<UnityEngine.AI.NavMeshObstacle>().enabled = true;

                    yield return new WaitForSeconds(redDuration);
                    currentState = TrafficLightState.Green;
                    break;

                case TrafficLightState.Green:
                    SetVisuals(Color.green, "Green");

                    GetComponent<UnityEngine.AI.NavMeshObstacle>().enabled = false;

                    yield return new WaitForSeconds(greenDuration);
                    currentState = TrafficLightState.Red;
                    break;
            }
        }
    }

    public void Hack()
    {
        if (currentState == TrafficLightState.Hacked) return;

        if (sequenceCoroutine != null)
        {
            StopCoroutine(sequenceCoroutine);
        }

        currentState = TrafficLightState.Hacked;
        GetComponent<UnityEngine.AI.NavMeshObstacle>().enabled = true;

        SetVisuals(Color.cyan, "Red");

        Debug.Log($"Semáforo [{gameObject.name}] ha sido hackeado.");
    }

    private void SetVisuals(Color color, string lightName)
    {
        switch (lightName)
        {
            case "Red":
                GameObject redLight = transform.Find("Red").gameObject;
                redLight.GetComponent<Renderer>().material.color = color;

                GameObject greenLight = transform.Find("Green").gameObject;
                greenLight.GetComponent<Renderer>().material.color = Color.gray;
                break;

            case "Green":
                GameObject greenLight2 = transform.Find("Green").gameObject;
                greenLight2.GetComponent<Renderer>().material.color = color;

                GameObject redLight2 = transform.Find("Red").gameObject;
                redLight2.GetComponent<Renderer>().material.color = Color.gray;
                break;

            case "Cyan":
                GameObject redLight3 = transform.Find("Red").gameObject;
                redLight3.GetComponent<Renderer>().material.color = color;

                GameObject greenLight3 = transform.Find("Green").gameObject;
                greenLight3.GetComponent<Renderer>().material.color = color;
                break;
        }
    }
}
