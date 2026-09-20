extends Control

@onready var username: LineEdit = %Username
@onready var host_room: MainButton = %HostRoom
@onready var room_id: LineEdit = %RoomId
@onready var join_room: MainButton = %JoinRoom
@onready var go_back: MainButton = %GoBack
@onready var error: Label = %Error

const LOBBY = preload("uid://cm6v3a2dss62y")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.DisplayMenu.connect(_hide_show_menu)
	error.text = ""
	
	Network.tube_client.error_raised.connect(_on_error_raised)
	
	# Buttons
	host_room.pressed.connect(_on_host_tube)
	join_room.pressed.connect(_on_join_tube)
	go_back.pressed.connect(_on_back_pressed)
	
	# Line Edits
	username.text_changed.connect(_on_username_changed)
	room_id.text_changed.connect(_on_room_id_changed)

func _hide_show_menu(id: Enums.Menu):
	if id == Enums.Menu.OnlineMenu:
		self.get_parent().show()
	else:
		self.get_parent().hide()

func _input(event: InputEvent) -> void:
	if not self.is_visible_in_tree():
		return
	
	if event.is_action_pressed("ui_accept") and not host_room.disabled:
		get_tree().get_root().set_input_as_handled()
		_on_host_tube()
	elif event.is_action_pressed("ui_select") and not join_room.disabled:
		get_tree().get_root().set_input_as_handled()
		_on_join_tube()
	elif event.is_action_pressed("ui_cancel"):
		get_tree().get_root().set_input_as_handled()
		_on_back_pressed()

func _on_back_pressed() -> void:
	EventBus.DisplayMenu.emit(Enums.Menu.MainMenu)

func _on_join_tube() -> void:
	multiplayer.connected_to_server.connect(Globals.add_world)
	Network.tube_join(room_id.text)

func _on_host_tube() -> void:
	Globals.host_and_spawn()

func _on_username_changed(new_text: String) -> void:
	if len(new_text) != 0:
		host_room.disabled = false
	else:
		host_room.disabled = true
	Globals.username = new_text

func _on_room_id_changed(new_text: String) -> void:
	if len(new_text) != 0:
		join_room.disabled = false
	else:
		join_room.disabled = true

func _on_error_raised(code, message):
	room_id.text = ""
	error.text = "%s: %s" % [code, message]
	Network.clean_up_signals()
