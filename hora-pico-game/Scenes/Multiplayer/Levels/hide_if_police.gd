extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Network.role_by_player[multiplayer.get_unique_id()] == Enums.Role.POLICE:
		self.hide()
