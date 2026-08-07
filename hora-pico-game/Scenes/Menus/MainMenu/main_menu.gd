extends Control

@onready var play_btn: Button = $ColorRect2/HBoxContainer/Play
@onready var quit_btn: Button = $ColorRect2/HBoxContainer/Quit

@onready var initial_menu: ColorRect = $ColorRect2

func _ready() -> void:
	EventBus.DisplayMenu.connect(_hide_show_if_should)
	play_btn.text = "[%s] Play" % Utils.get_key_or_button_for_action("ui_accept")
	quit_btn.text = "[%s] Quit" % Utils.get_key_or_button_for_action("ui_select")

func _hide_show_if_should(id: Enums.Menu):
	if id == Enums.Menu.MainMenu:
		initial_menu.show()
	else:
		initial_menu.hide()

func _input(event: InputEvent) -> void:
	if not initial_menu.is_visible_in_tree():
		return
	if event.is_action_pressed("ui_select"):
		_on_quit_pressed()
	if event.is_action_pressed("ui_accept"):
		_on_play_pressed()

func _on_play_pressed() -> void:
	EventBus.DisplayMenu.emit(Enums.Menu.RoleMenu)

func _on_quit_pressed() -> void:
	get_tree().quit()
