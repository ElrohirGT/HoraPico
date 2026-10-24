extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.DisplayMenu.connect(_on_display_menu)


func _on_display_menu(id: Enums.Menu):
	if id == Enums.Menu.TutorialMenu:
		self.hide()
	else:
		self.show()
