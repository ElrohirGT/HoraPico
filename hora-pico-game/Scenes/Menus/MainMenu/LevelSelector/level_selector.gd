extends MarginContainer

@onready var initial_menu: ColorRect = $"../ColorRect2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_traffic"):
		_on_level_1_button_pressed()
		
	if event.is_action_pressed("up_traffic"):
		_on_level_2_button_pressed()
		
	if event.is_action_pressed("right_traffic"):
		_on_level_3_button_pressed()

func _on_level_1_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")

func _on_level_2_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level2.tscn")

func _on_level_3_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level3.tscn")

func _on_quit_button_pressed() -> void:
	self.hide()
	initial_menu.show()
