extends PanelContainer

@onready var continue_btn: Button = $VBoxContainer/Continue
@onready var quit_btn: Button = $VBoxContainer/Quit

func _ready() -> void:
	self.hide()
	
	continue_btn.pressed.connect(_on_continue_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		print("PAUSING GAME...")
		if self.visible:
			self.hide()
		else:
			self.show()
		get_tree().paused = self.visible
	
	if event.is_action_pressed("ui_accept") and self.visible:
		_on_quit_pressed()


func _on_continue_pressed() -> void:
	self.hide()
	get_tree().paused = self.visible


func _on_quit_pressed() -> void:
	get_tree().quit()
