extends Control

@onready var initial_menu: UIBase = $".."
@onready var player: VideoStreamPlayer = %Player
@onready var back: MainButton = %Back


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.DisplayMenu.connect(_hide_show_if_should)
	back.pressed.connect(_on_back_pressed)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().get_root().set_input_as_handled()
		_on_back_pressed()

func _hide_show_if_should(id: Enums.Menu):
	if id == Enums.Menu.TutorialMenu:
		initial_menu.show()
		player.play()
	else:
		print("Hiding menu")
		player.stop()
		initial_menu.hide()

func _on_back_pressed():
	EventBus.DisplayMenu.emit(Enums.Menu.MainMenu)
