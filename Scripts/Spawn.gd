extends Marker2D

class_name Spawn

const CAR_SCENE = preload("res://Prefabs/car.tscn")

@export var destiny: Node2D # Le ponés el target al spawner 

@onready var car_timer = $Timer

static var car_next_priority = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	car_timer.wait_time = 1 # randf_range(0, 5)
	# call_deferred("car_spawn")

func _on_timer_timeout() -> void:
	call_deferred("car_spawn")
	
func car_spawn():
	var new_car: Car = CAR_SCENE.instantiate()
	new_car.global_position = global_position
	new_car.priority = Spawn.car_next_priority
	Spawn.car_next_priority += 1
	
	if destiny != null:
		new_car.movement_target_position = destiny.global_position
	
	else:
		print("No destino.")
	
	get_tree().current_scene.add_child(new_car)
	print("Car to: ", new_car.movement_target_position, "with ID: ", new_car.priority)
	car_timer.wait_time = 3 # randf_range(0, 5)
	car_timer.start()
