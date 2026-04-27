extends Node2D

class_name GameManager

static var winner: String = ""

func _ready() -> void:
	EventBus.game_ended.connect(_on_game_ended)
	
func _on_game_ended(winner: String) ->void:
	GameManager.winner = winner
	get_tree().change_scene_to_file("res://Scenes/end_menu.tscn")
