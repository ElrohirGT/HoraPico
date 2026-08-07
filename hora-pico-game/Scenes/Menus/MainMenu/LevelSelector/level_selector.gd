extends MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.DisplayMenu.connect(_hide_show_menu)
	pass # Replace with function body.

func _hide_show_menu(id: Enums.Menu):
	if id == Enums.Menu.LevelSelectMenu:
		self.show()
	else:
		self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_level_1_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")

func _on_level_2_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level2.tscn")

func _on_level_3_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level3.tscn")

func _on_quit_button_pressed() -> void:
	EventBus.DisplayMenu.emit(Enums.Menu.RoleMenu)
