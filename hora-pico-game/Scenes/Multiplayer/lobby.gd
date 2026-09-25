extends Node2D

class_name Lobby

@onready var role_selection_menu: RoleSelectionMenu = %RoleSelectionMenu
@onready var level_selector_menu: PanelContainer = %LevelSelectorMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.DisplayMenu.connect(_on_display_menu)

func _on_display_menu(menu: Enums.Menu):
	if multiplayer.is_server():
		display_menu.rpc(menu)

@rpc("authority", "call_local")
func display_menu(menu: Enums.Menu):
	role_selection_menu.hide()
	level_selector_menu.hide()
	
	if menu == Enums.Menu.LevelSelectMenu:
		level_selector_menu.show()
	elif menu == Enums.Menu.RoleMenu:
		role_selection_menu.show()
