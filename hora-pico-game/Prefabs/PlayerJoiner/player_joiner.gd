extends Node2D

@export var player_prefab: PackedScene
@export var traffic_player_prefab: PackedScene
@export var pointer_textures: Array[Texture2D]

var controllers: Dictionary = {}

func _ready() -> void:
	EventBus.DeviceConnected.connect(_spawn_new_player)
	EventBus.DeviceDisconnected.connect(_despawn_player)
	
	for device in InputManager.role_by_device:
		_spawn_new_player(device)

func _spawn_new_player(device: int):
	var node = null
	if Enums.Role.TRAFFIC == InputManager.role_by_device[device]:
		node = traffic_player_prefab.instantiate()
	else:
		node = player_prefab.instantiate()
		
	if node != null:
			node.set_device_id(device)
			node.texture = pointer_textures[device % len(pointer_textures)]
			add_child(node)
			controllers.set(device, node)

func _despawn_player(device: int):
	var node = controllers[device]
	node.queue_free()
	controllers.erase(device)
