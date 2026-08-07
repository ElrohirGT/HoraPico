extends Node



var player_count = -1
@export var role_by_device = {}

func _ready() -> void:
	Input.joy_connection_changed.connect(_on_joy_connection_changed)

func _on_joy_connection_changed(device: int, connected: bool):
	if connected:
		role_by_device[device] = Enums.Role.TRAFFIC
		player_count += 1
		
		if is_traffic_greater_than_one():
			role_by_device[device] = Enums.Role.POLICE
		EventBus.DeviceConnected.emit(device)
	else:
		role_by_device.erase(device)
		player_count -= 1
		EventBus.DeviceDisconnected.emit(device)

func is_traffic_greater_than_one() -> bool:
	var count = 0
	for device in role_by_device:
		if role_by_device[device] == Enums.Role.TRAFFIC:
			count+=1
	return count > 1
