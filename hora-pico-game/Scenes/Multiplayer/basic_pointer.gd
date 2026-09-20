extends Control

@export var moveMagnitude: float
@export var textures: Texture2D

@onready var pointer: TextureRect = %Pointer
@onready var pause_menu: PanelContainer = %PauseMenu

@onready var room_id: Label = %RoomId
@onready var copy: MainButton = %Copy
@onready var exit: MainButton = %Exit
@onready var pause_button: MainButton = %PauseButton


var selected: PlayerPointerButton = null
var device_id: int = 0

func _enter_tree() -> void:
	#var name_parts = self.get_parent().name.split("-", true, 2)
	#var peer_id = name_parts[0]
	#var player_name = name_parts[1]
	set_multiplayer_authority(int(self.get_parent().name))

func _ready() -> void:
	pointer.texture = textures
	add_to_group("Players")
	
	if not is_multiplayer_authority():
		set_process(false)
		set_physics_process(false)
		pause_button.hide()
		pause_menu.hide()
		return
	
	room_id.text = Network.tube_client.session_id
	pause_button.pressed.connect(_on_pause_button_pressed)
	copy.pressed.connect(_on_copy_pressed)
	exit.pressed.connect(_on_exit_pressed)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game") and is_multiplayer_authority():
		if pause_menu.is_visible_in_tree():
			pause_menu.hide()
			pause_button.show()
		else:
			pause_menu.show()
			pause_button.hide()

func _process(delta: float) -> void:
	var velocity := Vector2(
		Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(device_id, JOY_AXIS_LEFT_Y),
	).limit_length(1.0)
	if velocity.length() > 0.2 and not pause_menu.is_visible_in_tree():
		pointer.set_position(pointer.position + velocity * moveMagnitude)

func set_device_id(id: int):
	device_id = id

func _on_pause_button_pressed() -> void:
	pause_menu.show()
	pause_button.hide()

func _on_copy_pressed() -> void:
	var id = room_id.text
	DisplayServer.clipboard_set(id)
	room_id.text = "COPIED!"
	await get_tree().create_timer(0.750).timeout
	room_id.text = id

func _on_exit_pressed() -> void:
	Network.leave_server()
	get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu/MainMenu.tscn")
