using UnityEngine;
using UnityEngine.InputSystem;
using System.Collections.Generic;

public class TrafficComboManager : MonoBehaviour
{
    private InputSystem_Actions controls;

    [Header("Configuración de Objectivos")]
    [SerializeField] private Transform objectives;

    private List<Transform> objectivesList = new List<Transform>();

    [Header("Configuración de Vehículos")]
    [SerializeField] private GameObject carPrefab;
    [SerializeField] private GameObject busPrefab;

    [Header("Configuración de Combos")]
    [SerializeField] private float comboTimeout = 0.5f; // Tiempo máximo entre botones
    private List<string> currentSequence = new List<string>();
    private float lastInputTime;

    private void Start()
    {
        foreach (Transform objective in objectives)
        {
            objectivesList.Add(objective);
            Debug.Log("Objective añadido: " + objective.name);
        }
    }

    private void Awake()
    {
        controls = new InputSystem_Actions();

        controls.HoraPico.Arriba.performed += ctx => RegisterInput("Up");
        controls.HoraPico.Abajo.performed += ctx => RegisterInput("Down");
        controls.HoraPico.Izquierda.performed += ctx => RegisterInput("Left");
        controls.HoraPico.Derecha.performed += ctx => RegisterInput("Right");

        controls.HoraPico.Norte.performed += ctx => RegisterInput("-N");
        controls.HoraPico.Sur.performed += ctx => RegisterInput("-S");
        controls.HoraPico.Este.performed += ctx => RegisterInput("-E");
        controls.HoraPico.Oeste.performed += ctx => RegisterInput("-O");

        controls.HoraPico.Hack.performed += ctx => OnHackClick();
    }

    private void Update()
    {
        if (currentSequence.Count > 0 && Time.time - lastInputTime > comboTimeout)
        {
            CheckCombos();
            currentSequence.Clear();
            Debug.Log("Combo reseteado por tiempo");
        }
    }

    private void RegisterInput(string inputName)
    {
        currentSequence.Add(inputName);
        lastInputTime = Time.time;
        Debug.Log("Secuencia actual: " + string.Join("-", currentSequence));
    }

    private void CheckCombos()
    {
        string comboStr = string.Join("", currentSequence);
        string[] combo = comboStr.Split("-");

        string vehicleType = "";
        string vehicleSpawnPoint = "";

        switch (combo[0]) {
            case "UpDownLeftLeft":
                vehicleType = "Car";
                break;

            case "DownDownUpRight":
                vehicleType = "Bus";
                break;
        }

        if (combo.Length < 2 || vehicleType == "") return;

        switch (combo[1]) {
            case "N":
                vehicleSpawnPoint = "North";
                break;
            case "S":
                vehicleSpawnPoint = "South";
                break;
            case "E":
                vehicleSpawnPoint = "East";
                break;
            case "O":
                vehicleSpawnPoint = "West";
                break;
        }

        if (vehicleType != "" && vehicleSpawnPoint != "") {
            SpawnVehicle(vehicleType, vehicleSpawnPoint);
        }
    }

    private void SpawnVehicle(string type, string spawnPoint)
    {
        GameObject vehicle = null;
        switch (type) {
            case "Car":
                vehicle = carPrefab;
                break;
            case "Bus":
                vehicle = busPrefab;
                break;
        }

        if (vehicle == null) {
            Debug.LogError($"No se pudo cargar el prefab: {type}");
            return;
        }

        if (spawnPoint == "") {
            Debug.LogError($"No se pudo encontrar el spawner: {spawnPoint}");
            return;
        }

        GameObject spawnedVehicle = Instantiate(vehicle, transform.Find($"Spawner{spawnPoint}").position, Quaternion.identity);
        Debug.Log($"Spawneando: {type} en {spawnPoint}");

        Navigate navScript = spawnedVehicle.GetComponent<Navigate>();

        if (navScript != null) {
            navScript.Initialize(objectivesList);
        }
    }

    private void OnHackClick()
    {
        Ray ray = Camera.main.ScreenPointToRay(Mouse.current.position.ReadValue());
        if (Physics.Raycast(ray, out RaycastHit hit))
        {
            if (hit.collider.CompareTag("TrafficLight"))
            {
                TrafficLight trafficLight = hit.collider.GetComponent<TrafficLight>();
                if (trafficLight != null)
                {
                    trafficLight.Hack();
                }
            }
        }
    }

    private void OnEnable() => controls.HoraPico.Enable();
    private void OnDisable() => controls.HoraPico.Disable();
}
