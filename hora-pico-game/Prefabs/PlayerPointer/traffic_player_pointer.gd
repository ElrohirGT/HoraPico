extends Control

class_name TrafficPlayerPointer

@export var moveMagnitude: float
@export var texture: Texture2D

@onready var pointer: TextureRect = $Pointer

var selected: PlayerPointerButton = null
var device_id: int

func _ready() -> void:
	pointer.texture = texture
	
func _input(event: InputEvent):
	if event.device != device_id:
		return

func _process(delta: float) -> void:
	var velocity := Vector2(
		Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(device_id, JOY_AXIS_LEFT_Y),
	).limit_length(1.0)
	if velocity.length() > 0.2:
		set_position(position + velocity * moveMagnitude)
