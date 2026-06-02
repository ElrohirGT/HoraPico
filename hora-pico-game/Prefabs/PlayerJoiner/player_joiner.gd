extends Node2D

@export var player_prefab: PackedScene
@export var traffic_player_prefab: PackedScene
@export var pointer_textures: Array[Texture2D]

var controllers: Dictionary = {}
var player_index = -1

func _ready() -> void:
	Input.joy_connection_changed.connect(_on_joy_connection_changed)

func _on_joy_connection_changed(device: int, connected: bool):
	player_index += 1
	var node = null
	
	if player_index == 0:
		node = traffic_player_prefab.instantiate()
	else:
		node = player_prefab.instantiate()
	
	if node != null:
		node.device_id = device
		node.texture = pointer_textures[player_index % len(pointer_textures)]
		add_child(node)
		if connected:
			controllers.set(device, node)
		elif controllers.erase(device):
			print("Player %d disconnected!" % device)
		else:
			print("Player %d disconnected, but no device erased!" % device)
