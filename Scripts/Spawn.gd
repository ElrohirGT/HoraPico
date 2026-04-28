extends Marker2D

class_name Spawn

const CAR_SCENE = preload("res://Prefabs/car.tscn")
const BUS_SCENE = preload("res://Prefabs/Bus.tscn")

@export var destiny: Node2D # Le ponés el target al spawner 

@onready var carTimer: Timer = $Timer
@onready var manualTimer: Timer = $ManualTimer

static var car_next_priority = 0

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			if manualTimer.time_left == 0:
				manualTimer.start()
				carTimer.wait_time = 0.5
				print(carTimer.wait_time)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	carTimer.wait_time = 3 # randf_range(0, 5)
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
	
func bus_spawn():
	var new_bus: Bus = BUS_SCENE.instantiate()
	new_bus.global_position = global_position
	new_bus.priority = Spawn.car_next_priority
	Spawn.car_next_priority += 1
	
	if destiny != null:
		new_bus.movement_target_position = destiny.global_position
	
	else:
		print("No destino.")
	
	get_tree().current_scene.add_child(new_bus)
	print("Car to: ", new_bus.movement_target_position, "with ID: ", new_bus.priority)

func _on_manual_timer_timeout() -> void:
	carTimer.wait_time = 3
	print("Y volvemos a la normalidad")
