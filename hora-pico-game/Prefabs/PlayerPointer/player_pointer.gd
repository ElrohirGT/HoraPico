extends Control

class_name PlayerPointer

@export var moveMagnitude: float
@export var texture: Texture2D

@onready var pointer: TextureRect = $Pointer
@onready var menu: Control = $SummonMenu

@onready var top: PlayerPointerButton = $SummonMenu/Top
@onready var left: PlayerPointerButton = $SummonMenu/Left
@onready var right: PlayerPointerButton = $SummonMenu/Right
@onready var bottom: PlayerPointerButton = $SummonMenu/Bottom

var selected: PlayerPointerButton = null
var device_id: int

func _ready() -> void:
	pointer.texture = texture
	menu.hide()
	
func _input(event: InputEvent):
	if event.device != device_id:
		return
	
	if selected != null && event.is_action_pressed("spend_elixir"):
		EventBus.InvokeAbility.emit(selected.ability, selected.cost)
	

func _process(delta: float) -> void:
	var velocity := Vector2(
		Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(device_id, JOY_AXIS_LEFT_Y),
	).limit_length(1.0)
	if velocity.length() > 0.2:
		set_position(position + velocity * moveMagnitude)
	
	var selection_vel := Vector2(
		Input.get_joy_axis(device_id, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(device_id, JOY_AXIS_RIGHT_Y),
	).limit_length(1.0)
	if selection_vel.length() < 0.2:
		menu.hide()
	else:
		selected = null
		right.selected = false
		left.selected = false
		top.selected = false
		bottom.selected = false
		
		var angle = selection_vel.angle()
		if is_between(angle, -PI/4, PI/4):
			selected = right
		elif is_between(angle, -3*PI/4, -PI/4):
			selected = top
		elif is_between(angle, PI/4, 3*PI/4):
			selected = bottom
		else:
			selected = left
		selected.selected = true
		menu.show()

func is_between(val: float, min_val: float, max_val: float) -> bool:
	return val >= min_val and val <= max_val
