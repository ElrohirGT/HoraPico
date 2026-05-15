using System;
using UnityEngine;
using UnityEngine.AI;
using System.Collections.Generic;

[RequireComponent(typeof(NavMeshAgent))]
public class Navigate : MonoBehaviour
{
    private NavMeshAgent agent;
    private bool initialized = false;
    private int randomWaypointIndex;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    public void Initialize(List<Transform> waypoints)
    {
        agent = GetComponent<NavMeshAgent>();
        Debug.Log("Inicializado con: " + waypoints.Count + " objetivos");

        if (waypoints.Count > 0)
        {
            randomWaypointIndex = UnityEngine.Random.Range(0, waypoints.Count);
            agent.SetDestination(waypoints[randomWaypointIndex].position);
            initialized = true;
            Debug.Log("Destino establecido: " + waypoints[randomWaypointIndex].name);

        } else {
            Debug.LogWarning("No waypoints provided for navigation.");
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (!initialized) return;

        if (!agent.pathPending && agent.remainingDistance < 0.5f)
        {
            Destroy(gameObject);
        }
    }
}
