extends Control

enum PointerState {POINTING, IN_RANGE, SUMMONING}

@export var moveMagnitude: float
@export var texture: Texture2D

@onready var pointer: TextureRect = $Pointer
@onready var menu: Control = $SummonMenu

@onready var top: PlayerPointerButton = $SummonMenu/Top
@onready var left: PlayerPointerButton = $SummonMenu/Left
@onready var right: PlayerPointerButton = $SummonMenu/Right
@onready var bottom: PlayerPointerButton = $SummonMenu/Bottom

var state: PointerState = PointerState.POINTING
var selected: PlayerPointerButton = null

func _ready() -> void:
	pointer.texture = texture
	menu.hide()
	
func _input(event: InputEvent) -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_pressed("south_traffic"):
		state = PointerState.IN_RANGE
	else:
		if state == PointerState.IN_RANGE:
			# TODO: Handle transition from InRange to Pointing
			if selected != null:
				EventBus.InvokeAbility.emit(selected.ability, selected.cost)
		state = PointerState.POINTING
		
	var velocity = Input.get_vector("left_traffic", "right_traffic", "up_traffic", "down_traffic") * moveMagnitude
	if state == PointerState.POINTING:
		set_position(position + velocity)
		menu.hide()
	elif state == PointerState.IN_RANGE:
		selected = null
		right.selected = false
		left.selected = false
		top.selected = false
		bottom.selected = false
		if not is_equal_approx(0, velocity.length()):
			var angle = velocity.angle()
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
	else:
		menu.hide()

func is_between(val: float, min_val: float, max_val: float) -> bool:
	return val >= min_val and val <= max_val
