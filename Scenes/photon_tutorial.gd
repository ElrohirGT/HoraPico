extends Node3D

const HostCharacter = preload("res://Prefabs/authority_character_3d.tscn")
const ClientCharacter = preload("res://Prefabs/slave_character_3d.tscn")

@onready var spawner: FusionSpawner = $FusionSpawner

func _ready():
	Fusion.room_joined.connect(_on_room_joined)
	Fusion.register_broadcast_receiver(self)  # enables this node to receive broadcast RPCs
	spawner.add_spawnable_scene(HostCharacter)
	spawner.add_spawnable_scene(ClientCharacter)

	Fusion.connect_to_photon("user_%d" % randi())
	Fusion.connected_to_photon.connect(func():
		Fusion.join_or_create_room()
	)

func _on_room_joined():
	print("Connected! ", Fusion.get_local_player_id())
	if Fusion.is_master_client():
		_spawn_character(Fusion.get_local_player_id(), true)
	else:
		Fusion.rpc(request_spawn)

@rpc("any_peer", "call_local")
func request_spawn():
	if not Fusion.is_master_client():
		return
	var sender_id = Fusion.get_rpc_sender_id()
	_spawn_character(sender_id, false)

func _spawn_character(player_id: int, is_master: bool):
	var ch = ClientCharacter
	if is_master:
		ch = HostCharacter
	var character = spawner.spawn(ch)
	character.position = Vector3(randf_range(-4, 4), 1.0, randf_range(-4, 4))
	character.get_node("FusionServerReplicator").set_input_authority(player_id)
