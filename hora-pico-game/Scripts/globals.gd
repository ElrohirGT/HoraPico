extends Node

var username: String
var elixir_quantity: float

var day_state: int

func add_world():
	get_tree().change_scene_to_file("res://Scenes/Multiplayer/Lobby.tscn")

func host_and_spawn():
	var tree = get_tree()
	add_world()
	await get_tree().scene_changed
	Network.tube_create()

func is_multiplayer() -> bool:
	return len(multiplayer.get_peers()) > 0

# ===================================
# Calls from the server to clients
# ===================================
@rpc("authority", "call_local")
func game_ended(param: String):
	EventBus.GameEnded.emit(param)

@rpc("authority", "call_local")
func daytime_changed(day_state: Enums.DayStates):
	EventBus.daytime_changed.emit(day_state)


# ===================================
# Calls from the clients to the server
# ===================================
@rpc("any_peer", "call_local")
func change_role(peer_id: int, role: Enums.Role):
	EventBus.ChangeRole.emit(peer_id, role)

@rpc("any_peer", "call_local")
func invoke_ability(peer_id: int, ability: Enums.Ability, cost: float):
	EventBus.InvokeAbility.emit(peer_id, ability, cost)
