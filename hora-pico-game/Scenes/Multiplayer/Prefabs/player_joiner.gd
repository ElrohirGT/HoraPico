extends Node2D

var police_pointer = preload("res://Scenes/Multiplayer/Prefabs/PlayerPointer/PlayerPointer.tscn")
var traffic_pointer = preload("res://Scenes/Multiplayer/Prefabs/PlayerPointer/TrafficPlayerPointer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for pid in Network.role_by_player:
		var role = Network.role_by_player[pid]
		var pointer
		if role == Enums.Role.POLICE:
			pointer = police_pointer.instantiate()
		elif role == Enums.Role.TRAFFIC:
			pointer = traffic_pointer.instantiate()
		pointer.name = str(pid)
		pointer.texture = ImageTexture.create_from_image(Network.textures[Network.texture_by_player[pid]])
		get_tree().current_scene.add_child.call_deferred(pointer)
