extends Marker2D

const CAR_SCENE = preload("res://Prefabs/Car.tscn")

@export var destiny: Node2D # Le ponés el target al spawner 

@onready var car_timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	car_timer.wait_time = randf_range(0, 1)
	call_deferred("car_spawn")

func _on_timer_timeout() -> void:
	call_deferred("car_spawn")
	
func car_spawn():
	var new_car = CAR_SCENE.instantiate()
	new_car.global_position = global_position
	
	if destiny != null:
		new_car.movement_target_position = destiny.global_position
	
	else:
		print("No destino.")
	
	get_tree().current_scene.add_child(new_car)
	print("Car to: ", new_car.movement_target_position)
	car_timer.wait_time = randf_range(0, 3)
	car_timer.start()
