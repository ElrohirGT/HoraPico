extends Node2D

@export var objs: Array[PackedScene]

@export var min_seconds: float
@export var max_seconds: float

@onready var alert: Alert = $Alert

var timer: Timer
var targets: Array[Node]

func _ready() -> void:
	targets = get_tree().root.find_children("End*", "Marker2D", true, false)
	print("Found %d ends!" % len(targets))
	
	timer = Timer.new()
	timer.timeout.connect(_on_spawn_vehicle)
	add_child(timer)
	
	timer.start(0.3)


func _on_spawn_vehicle() -> void:
	timer.start(randf() * (max_seconds - min_seconds) + min_seconds)
	alert.display()
	var new_vehicle = objs.pick_random().instantiate()
		
	if new_vehicle != null:
		new_vehicle.global_position = self.global_position
		new_vehicle.movement_target_position = targets.pick_random().global_position
		
		get_tree().current_scene.add_child(new_vehicle)
