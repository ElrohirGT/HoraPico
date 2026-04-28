extends Control

func _ready() -> void:
	$VBoxContainer/Title.text = "%s Wins!" % GameManager.winner

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
