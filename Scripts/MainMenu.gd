extends Node

var next_player_id = 0
var players_connected: Dictionary = {}

@export var player_scene: PackedScene

func _input(event):
	if event is InputEventJoypadButton and event.is_pressed():
		var id = next_player_id
		next_player_id+=1
		
		if not players_connected.has(id):
			join_player(id)

func join_player(id):
	var new_player = player_scene.instantiate()
	new_player.player_id = id
	new_player.position = Vector2(200 * (players_connected.size() + 1), 200)
	
	add_child(new_player)
	
	players_connected[id] = new_player
	
	print("Nuevo jugador con ID: ", id)
