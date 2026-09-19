extends Button

class_name MainButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.DeviceConnected.connect(update_ui)
	EventBus.DeviceDisconnected.connect(update_ui)

func update_ui(_id: int):
	var icon = self.icon
	
	if icon is ControllerIconTexture:
		if InputManager.is_any_joycon_connected():
			icon.force_type = ControllerIconTexture.ForceType.CONTROLLER
		else:
			icon.force_type = ControllerIconTexture.ForceType.NONE
	
	self.icon = icon
