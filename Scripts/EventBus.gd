extends Node

# Game signals
signal game_ended(winner: String)

# Car processing signals
signal car_despawned
signal car_spawned

# TrafficLight processing signals
signal traffic_light_clicked(trafficLight: TrafficLight)
