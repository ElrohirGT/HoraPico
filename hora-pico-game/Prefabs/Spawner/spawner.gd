extends Marker2D

class_name Spawn

const CAR_SCENE = preload("res://Prefabs/Car/Car.tscn")
const BUS_SCENE = preload("res://Prefabs/Bus/Bus.tscn")

@export var destiny: Node2D # Le ponés el target al spawner 

@onready var vehicle_timer = $Car_Timer
@onready var combo_timer = $Combo_Timer

static var vehicle_next_priority = 0

var combo: String = ""
var direction: String = ""

func _input(event: InputEvent) -> void:
	var vehicleType = ""
	
	if not event.is_pressed() or event.is_echo():
		return
	
	if event.is_action_pressed("up_traffic"):
		combo += "U"
		combo_timer.start()
		
	elif event.is_action_pressed("down_traffic"):
		combo += "D"
		combo_timer.start()
		
	elif event.is_action_pressed("right_traffic"):
		combo += "R"
		combo_timer.start()
		
	elif event.is_action_pressed("left_traffic"):
		combo += "L"
		combo_timer.start()
	
	if event.is_action_pressed("north_traffic"):
		direction = "N"
		combo_timer.start()
		
	if event.is_action_pressed("south_traffic"):
		direction = "S"
		combo_timer.start()
		
	if event.is_action_pressed("east_traffic"):
		direction = "E"
		combo_timer.start()
		
	if event.is_action_pressed("west_traffic"):
		direction = "W"
		combo_timer.start()
		
	if combo.ends_with("UDLL"):
		vehicleType = "Car"
		
	elif combo.ends_with("DDUR"):
		vehicleType = "Bus"
		
	if vehicleType == "":
		return
		
	if direction == "":
		return
		
	print("Combo: ", combo, " | Dirección: ", direction, " | Tipo: ", vehicleType )
	call_deferred("vehicle_spawn", vehicleType, direction)
	
	combo = ""
	direction = ""

func vehicle_spawn(vehicleType: String, spawnPosition: String):
	var new_vehicle
	
	if vehicleType == "Car":
		new_vehicle = CAR_SCENE.instantiate()
	
	elif vehicleType == "Bus":
		new_vehicle = BUS_SCENE.instantiate()
		
	if new_vehicle != null and spawnPosition != null:
		new_vehicle.global_position = global_position
		new_vehicle.priority = Spawn.vehicle_next_priority
		Spawn.vehicle_next_priority += 1
		
		if destiny != null:
			new_vehicle.movement_target_position = destiny.global_position
		
		else:
			print("No destino.")
			return
		
		get_tree().current_scene.add_child(new_vehicle)
		print("%s to: " % vehicleType, new_vehicle.movement_target_position, "with ID: ", new_vehicle.priority) # Está curioso el format string aquí xd
		vehicle_timer.wait_time = 3 # randf_range(0, 5)
		vehicle_timer.start()

func _on_combo_timer_timeout() -> void:
	combo = ""
	direction = ""
	print("Combo reseteado por timeout.")
