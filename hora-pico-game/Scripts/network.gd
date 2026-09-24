extends Node

const PLAYER = preload("uid://c0pj4kpj0xop")
const TUBE_CONTEXT = preload("uid://dbr6ei2y17wsm")

var enet_peer := ENetMultiplayerPeer.new()
var tube_client := TubeClient.new()

var tube_enabled = true

var PORT = 9999
var IP_ADDRESS = '127.0.0.1'

var root_by_player = {}

func _ready() -> void:
	if tube_enabled:
		tube_client.context = TUBE_CONTEXT
		get_tree().root.add_child.call_deferred(tube_client)

func tube_create():
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	tube_client.create_session()
	add_player.call_deferred(1)

func tube_join(session_id: String):
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	multiplayer.connected_to_server.connect(on_connected_to_server)
	tube_client.join_session(session_id)

func on_connected_to_server():
	add_player(multiplayer.get_unique_id())

func add_player(peer_id: int):
	EventBus.PlayerJoining.emit(peer_id)
	print("Trying to add the player %d to the scene!" % peer_id)
	if peer_id == 1 and multiplayer.multiplayer_peer is ENetMultiplayerPeer:
		return
	
	var new_player = PLAYER.instantiate()
	new_player.name = str(peer_id)
	
	if get_tree().current_scene == null:
		await get_tree().scene_changed
	get_tree().current_scene.add_child(new_player, true)
	root_by_player[peer_id] = new_player
	print("Added player %d!" % peer_id)
	EventBus.PlayerJoined.emit(peer_id)

func remove_player(peer_id):
	if peer_id == 1:
		leave_server()
	
	var players: Array[Node] = get_tree().get_nodes_in_group('Players')
	var player_to_remove = players.find_custom(func(item): return item.name == str(peer_id))
	if player_to_remove != -1:
		players[player_to_remove].queue_free()
		
func leave_server():
	if tube_enabled:
		tube_client.leave_session()
	
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	clean_up_signals()
	# get_tree().reload_current_scene()
	
func clean_up_signals():
	multiplayer.peer_connected.disconnect(add_player) 
	multiplayer.peer_disconnected.disconnect(remove_player)
	multiplayer.connected_to_server.disconnect(on_connected_to_server)

func _exit_tree() -> void:
	if tube_enabled:
		tube_client.leave_session()
