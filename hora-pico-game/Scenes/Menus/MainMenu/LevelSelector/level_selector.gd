extends MarginContainer

@onready var level_1_button: Button = %Level1Button
@onready var level_2_button: Button = %Level2Button
@onready var level_3_button: Button = %Level3Button
@onready var quit_button: Button = %QuitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.DisplayMenu.connect(_hide_show_menu)
	level_1_button.pressed.connect(_on_level_1_button_pressed)
	level_2_button.pressed.connect(_on_level_2_button_pressed)
	level_3_button.pressed.connect(_on_level_3_button_pressed)
	
	quit_button.pressed.connect(_on_quit_button_pressed)

func _hide_show_menu(id: Enums.Menu):
	if id == Enums.Menu.LevelSelectMenu:
		self.show()
	else:
		self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if not self.is_visible_in_tree():
		return
		
	if event.is_action_pressed("left_traffic"):
		get_tree().get_root().set_input_as_handled()
		_on_level_1_button_pressed()
	elif event.is_action_pressed("up_traffic"):
		get_tree().get_root().set_input_as_handled()
		_on_level_2_button_pressed()
	elif event.is_action_pressed("right_traffic"):
		get_tree().get_root().set_input_as_handled()
		_on_level_3_button_pressed()
	elif event.is_action_pressed("ui_select"):
		get_tree().get_root().set_input_as_handled()
		_on_quit_button_pressed()

func _on_level_1_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")

func _on_level_2_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level2.tscn")

func _on_level_3_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level3.tscn")

func _on_quit_button_pressed() -> void:
	EventBus.DisplayMenu.emit(Enums.Menu.RoleMenu)
