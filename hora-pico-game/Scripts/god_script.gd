extends Node2D

const CAR_SCENE = preload("res://Prefabs/Car/Car.tscn")
const BUS_SCENE = preload("res://Prefabs/Bus/Bus.tscn")

@export var destinies: Node2D # Le ponés el target al spawner 
@export var ultimate_charges: int = 1

@export var neutral_arrow: Texture2D
@export var correct_arrow: Texture2D
@export var wrong_arrow: Texture2D

@export var car_texture: Texture2D
@export var bus_texture: Texture2D
@export var ulti_texture: Texture2D

enum Directions{UP, DOWN, LEFT, RIGHT}
var done: Array[Directions]
var car_pattern: Array[Directions]
var bus_pattern: Array[Directions]

var selected_pattern: int = 0

var vehicleType: String

enum Velocity{ F, E, D, C, B, A, S }
@export var currentVelocity = Velocity.F

@onready var vehicle_timer: Timer = $"../Car_Timer"
@onready var combo_timer: Timer = $"../Combo_Timer"
@onready var velocity_timer: Timer = $"../Velocity_Timer"

@onready var velocity_label: Label = $"../CanvasLayer/HUD/ColorRect/VelocityLabel"
@onready var ultimate_label: Label = $"../CanvasLayer/HUD/ColorRect/UltimateCharges"

@onready var car_combo_container: HBoxContainer = $"../CanvasLayer/HUD/TrafficBackground/CarComboQueue"
@onready var bus_combo_container: HBoxContainer = $"../CanvasLayer/HUD/TrafficBackground2/BusComboQueue"

@onready var audio_player: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"
@onready var failure_audio_player: AudioStreamPlayer2D = $"../AudioStreamPlayer2D2"

@onready var fail_timer: Timer

@onready var spawners: Dictionary = {
	"N": $SpawnerN,
	"S": $SpawnerS,
	"E": $SpawnerE,
	"W": $SpawnerW
}
@onready var spawners_indicators: Dictionary = {
	"N": $SpawnerN/Alert,
	"S": $SpawnerS/Alert,
	"E": $SpawnerE/Alert,
	"W": $SpawnerW/Alert
}

static var vehicle_next_priority = 0

var combo: Directions
var direction: String = ""
var waiting_for_direction: bool = false

static var last_combo: String = ""
static var last_direction: String = ""

@onready var spawn_cooldown: Timer = $Timer

func _ready() -> void:
	#EventBus.VehicleChanged.connect(_on_vehicle_changed)
	#EventBus.VehicleChanged.emit(0)
	spawn_cooldown.timeout.connect(_on_spawn_cooldown_done)
	random_gen()

func _input(event: InputEvent) -> void:
	if not event.is_pressed() or event.is_echo():
		return
		
	if waiting_for_direction:
		if event.is_action_pressed("north_traffic"):
			direction = "N"
		elif event.is_action_pressed("south_traffic"):
			direction = "S"
		elif event.is_action_pressed("east_traffic"):
			direction = "E"
		elif event.is_action_pressed("west_traffic"):
			direction = "W"
		else:
			return

		if direction != "":
			waiting_for_direction = false
			call_deferred("_on_pattern_complete")
			
		else:
			waiting_for_direction = false
			call_deferred("_on_pattern_mistake")
			
		return
	
	var idx = len(done)
	var expected
	var pattern
	
	if selected_pattern == 0:
		if idx >= len(car_pattern):
			call_deferred("_on_pattern_mistake")
			return
		
		expected = car_pattern[idx]
		pattern = car_pattern
		
	else:
		if idx >= len(bus_pattern):
			call_deferred("_on_pattern_mistake")
			return
		
		expected = bus_pattern[idx]
		pattern = bus_pattern
	
	if event.is_action_pressed("up_traffic"):
		combo = Directions.UP
		
	elif event.is_action_pressed("down_traffic"):
		combo = Directions.DOWN
		
	elif event.is_action_pressed("right_traffic"):
		combo = Directions.RIGHT
		
	elif event.is_action_pressed("left_traffic"):
		combo = Directions.LEFT
		
	else:
		return
		
	print(combo, expected)
	
	if combo != expected:
		failure_audio_player.play()
		call_deferred("_on_pattern_mistake")
		combo_timer.start()

	if combo == expected :
		done.append(combo)
		
		refresh_combo_display()
		
		if done.size() == pattern.size():
			if currentVelocity == Velocity.S:
				call_deferred("_on_pattern_complete")
				
			else:
				waiting_for_direction = true

func refresh_combo_display():
	for child in car_combo_container.get_children():
		child.queue_free()

	for child in bus_combo_container.get_children():
		child.queue_free()

	generate_combo()

func _on_pattern_mistake():
	done = []
	
	combo_timer.start()
	
	var containers: Array = [car_combo_container, bus_combo_container]
	
	for container in containers:
		for child in container.get_children():
			child.queue_free()
	
	refresh_combo_display()

func lock_traffic_spawn() -> void:
	pass

func _on_pattern_complete():
	var containers: Array = [car_combo_container, bus_combo_container]
	done = []
	
	combo_timer.start()
	
	if currentVelocity == Velocity.S:
		cast_ultimate()
		
	else:
		call_deferred("vehicle_spawn", vehicleType, direction)
		speeding_up(vehicleType)
	
	for container in containers:
		for child in container.get_children():
			child.queue_free()
	
	direction = ""
	random_gen()

func generate_random_pattern() -> Array[Directions]:
	var directions = [Directions.UP, Directions.DOWN, Directions.LEFT, Directions.RIGHT]
	var new_pattern: Array[Directions]
	var length: int
	
	if currentVelocity != Velocity.S:
		length = randi_range(3, 4)
		
	else:
		length = 6

	for i in length:
		new_pattern.append(directions.pick_random())
	
	return new_pattern
	
func generate_random_spawner() -> String:
	var spawners: Array[String] = ["N", "S", "E", "W"]
	
	return spawners.pick_random()

func generate_combo():
	var patterns: Array = [car_pattern, bus_pattern]
	var containers: Array = [car_combo_container, bus_combo_container]
	
	for pattern in patterns:
		var combo: HBoxContainer = HBoxContainer.new()
		combo.set_anchors_preset(Control.PRESET_CENTER)
		combo.add_theme_constant_override("separation", 40)
	
		for idx in pattern.size():
			
			var p = pattern[idx]
			
			var texture_container: Control = Control.new()
			
			var texture: TextureRect = TextureRect.new()
			texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			texture.custom_minimum_size = Vector2(32, 32)
			texture.set_anchors_preset(Control.PRESET_CENTER)
			texture.pivot_offset_ratio = Vector2(0.5, 0.5)
			texture.texture = neutral_arrow
			
			if p == Directions.DOWN:
				texture.rotation_degrees = 180
			if p == Directions.RIGHT:
				texture.rotation_degrees = 90
			if p == Directions.LEFT:
				texture.rotation_degrees = -90
				
			if patterns.find(pattern) == selected_pattern:
				if idx < done.size():
					var selected = done[idx]
					if selected != p:
						texture.texture = wrong_arrow
					else:
						texture.texture = correct_arrow
						audio_player.play()
			
			texture_container.add_child(texture)
			combo.add_child(texture_container)
	
		containers[patterns.find(pattern)].add_child(combo)

func random_gen() -> void:
	car_pattern = generate_random_pattern()
	bus_pattern = generate_random_pattern()
	
	if randi() % 2 == 0:
		vehicleType = "Car"
	
	else:
		vehicleType = "Bus"
	
	generate_combo()

var index: int
func _on_spawn_cooldown_done():
	if index >= ultimate_charges:
		index = 0
		return
	
	spawn_cooldown.start()
	var vehicles: Array = ["Car", "Bus"]
	var random_vehicle: String = vehicles.pick_random()
	var spawnersKeys: Array = spawners.keys()
	vehicle_spawn(random_vehicle, spawnersKeys.pick_random())
	index += 1

func cast_ultimate() -> void:
	var vehicles: Array = ["Car", "Bus"]
	var random_vehicle: String = vehicles.pick_random()
	var spawnersKeys: Array = spawners.keys()
	
	spawn_cooldown.start()
	ultimate_charges += 1
	ultimate_label.text = "Charges: " + str(ultimate_charges)
	
	velocity_timer.stop()
	velocity_timer.timeout.emit()

func vehicle_spawn(vehicleType: String, spawnPosition: String) -> void:
	EventBus.VehicleSpawned.emit()
	print(vehicleType, spawnPosition)
	
	var new_vehicle
	
	if vehicleType == "Car":
		new_vehicle = CAR_SCENE.instantiate()
	
	elif vehicleType == "Bus":
		new_vehicle = BUS_SCENE.instantiate()
		
	if new_vehicle != null:
		new_vehicle.global_position = spawners[spawnPosition].global_position
		spawners_indicators[spawnPosition].display()
		new_vehicle.priority = vehicle_next_priority
		vehicle_next_priority += 1
		
		if destinies != null:
			var random_objective: Marker2D = destinies.get_children().pick_random()
			new_vehicle.movement_target_position = random_objective.global_position
		
		else:
			print("No destino.")
			return
		
		get_tree().current_scene.add_child(new_vehicle)
		print("%s to: " % vehicleType, new_vehicle.movement_target_position, "with ID: ", new_vehicle.priority) # Está curioso el format string aquí xd
		
		last_combo = vehicleType
		last_direction = spawnPosition
		
		vehicle_timer.wait_time = 3 # randf_range(0, 5)
		vehicle_timer.start()

func speeding_up(combo: String):
	if currentVelocity < 5:
		currentVelocity = (currentVelocity + 1)
		
	else:
		currentVelocity = Velocity.S
	
	velocity_label.text = Velocity.keys()[currentVelocity]
	velocity_timer.start()
		
func _on_combo_timer_timeout() -> void:
	call_deferred("_on_pattern_mistake")
	direction = ""
	waiting_for_direction = false
	print("Combo reseteado por timeout.")

func _on_velocity_timer_timeout() -> void:
	currentVelocity = Velocity.F
	velocity_label.text = Velocity.keys()[currentVelocity]
	print("Velocidad (Rango) reseteada por timeout.")

func _on_mistake_display_timer_timeout() -> void:
	call_deferred("_on_pattern_mistake")
