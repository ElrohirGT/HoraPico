extends Control

@onready var username: LineEdit = %Username
@onready var host_room: MainButton = %HostRoom
@onready var room_id: LineEdit = %RoomId
@onready var join_room: MainButton = %JoinRoom
@onready var go_back: MainButton = %GoBack


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.DisplayMenu.connect(_hide_show_menu)
	go_back.pressed.connect(_on_back_pressed)
	

func _hide_show_menu(id: Enums.Menu):
	if id == Enums.Menu.OnlineMenu:
		self.get_parent().show()
	else:
		self.get_parent().hide()

func _input(event: InputEvent) -> void:
	if not self.is_visible_in_tree():
		return
	
	if event.is_action_pressed("ui_accept"):
		pass # Host room
	elif event.is_action_pressed("ui_select"):
		pass # Join room
	elif event.is_action_pressed("ui_cancel"):
		get_tree().get_root().set_input_as_handled()
		_on_back_pressed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_pressed() -> void:
	EventBus.DisplayMenu.emit(Enums.Menu.MainMenu)
