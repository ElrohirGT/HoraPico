extends Node

var username: String

func add_world():
	get_tree().change_scene_to_file("res://Scenes/Multiplayer/Lobby.tscn")

func host_and_spawn():
	var tree = get_tree()
	add_world()
	await get_tree().scene_changed
	Network.tube_create()

@rpc("any_peer", "call_local")
func change_role(peer_id: int, role: Enums.Role):
	EventBus.ChangeRole.emit(peer_id, role)
