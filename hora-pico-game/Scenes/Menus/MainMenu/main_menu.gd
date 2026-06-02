extends Control

@onready var play_btn: Button = $ColorRect2/HBoxContainer/Play
@onready var quit_btn: Button = $ColorRect2/HBoxContainer/Quit

func _ready() -> void:
	play_btn.text = "[%s] Play" % Utils.get_key_or_button_for_action("ui_accept")
	quit_btn.text = "[%s] Quit" % Utils.get_key_or_button_for_action("ui_select")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		_on_quit_pressed()
	if event.is_action_pressed("ui_accept"):
		_on_play_pressed()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
