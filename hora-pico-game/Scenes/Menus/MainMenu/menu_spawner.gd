extends Node2D

@export var objs: Array[PackedScene]

@export var target: Marker2D
@export var min_seconds: float
@export var max_seconds: float

var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	timer.timeout.connect(_on_spawn_vehicle)
	add_child(timer)
	
	timer.start(0.3)


func _on_spawn_vehicle() -> void:
	timer.start(randf() * (max_seconds - min_seconds) + min_seconds)
	var new_vehicle = objs.pick_random().instantiate()
		
	if new_vehicle != null:
		new_vehicle.global_position = self.global_position
		new_vehicle.movement_target_position = target.global_position
		
		get_tree().current_scene.add_child(new_vehicle)
