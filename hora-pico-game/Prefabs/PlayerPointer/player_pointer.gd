extends Control

class_name PlayerPointer

@export var moveMagnitude: float
@export var texture: Texture2D

@onready var pointer: TextureRect = $Pointer

@onready var top: PlayerPointerButton = $SummonMenu/Top
@onready var left: PlayerPointerButton = $SummonMenu/Left
@onready var right: PlayerPointerButton = $SummonMenu/Right
@onready var bottom: PlayerPointerButton = $SummonMenu/Bottom

@onready var police_radius: TextureRect = $PoliceRadius

var selected: PlayerPointerButton = null
var device_id: int

func _ready() -> void:
	police_radius.hide()
	pointer.texture = texture
	
	print("Creating pointer with id: %d" % device_id)
	
func _input(event: InputEvent):
	if event.device != device_id:
		return
	
	if selected != null && event.is_action_pressed("spend_elixir"):
		print("Emitting ability %d - src %d" % [selected.ability, device_id])
		EventBus.InvokeAbility.emit(device_id, selected.ability, selected.cost)
	

func _process(delta: float) -> void:
	police_radius.hide()
	var velocity := Vector2(
		Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(device_id, JOY_AXIS_LEFT_Y),
	).limit_length(1.0)
	if velocity.length() > 0.2:
		set_position(position + velocity * moveMagnitude)

func is_between(val: float, min_val: float, max_val: float) -> bool:
	return val >= min_val and val <= max_val

func set_device_id(id: int):
	device_id = id
	$TrafficLightCombo.device_id = id
	$PoliceRadius.device_id = id
