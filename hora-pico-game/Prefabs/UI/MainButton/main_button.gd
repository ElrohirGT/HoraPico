extends Button

class_name MainButton

@export var prefix_format: String
@export var button_text: String
@export var action: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.DeviceConnected.connect(update_ui)
	EventBus.DeviceDisconnected.connect(update_ui)
	update_ui(0)

func update_ui(_id: int):
	self.text = Utils.format_button_text(prefix_format, button_text, action)
