extends Node2D

var police_pointer = preload("uid://b6wqoduvxio1f")
var traffic_pointer = preload("uid://bb088elnbb48c")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var pointer
	for pid in Network.role_by_player:
		if pid == Enums.Role.POLICE:
			pointer = police_pointer.instantiate()
		elif pid == Enums.Role.TRAFFIC:
			pointer = traffic_pointer.instantiate()
		pointer.texture = Network.texture_by_player[pid]
	get_tree().current_scene.add_child(pointer)
