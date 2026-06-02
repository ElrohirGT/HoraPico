extends PanelContainer

@onready var title: Label = $VBoxContainer/Label

@onready var play_again: Button = $VBoxContainer/PlayAgain
@onready var main_menu: Button = $VBoxContainer/MainMenu

func _ready() -> void:
	EventBus.GameEnded.connect(_on_game_ended)
	self.hide()
	
	play_again.text = "[%s] Play Again" % Utils.get_key_or_button_for_action("ui_accept")
	main_menu.text = "[%s] Main Menu" % Utils.get_key_or_button_for_action("ui_select")

func _input(event: InputEvent) -> void:
	if not self.visible:
		return
		
	if event.is_action_pressed("ui_accept"):
		_on_play_again_pressed()
	if event.is_action_pressed("ui_select"):
		_on_main_menu_pressed()

func _on_game_ended(winner: String):
	self.show()
	title.text = "%s Wins!" % winner

func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu/MainMenu.tscn")
