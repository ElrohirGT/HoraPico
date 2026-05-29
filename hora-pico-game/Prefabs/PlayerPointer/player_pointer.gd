extends Control

@export var moveMagnitude: float
@export var texture: Texture2D

@onready var pointer: TextureRect = $Pointer
@onready var menu: Control = $SummonMenu

@onready var top: PlayerPointerButton = $SummonMenu/Top
@onready var left: PlayerPointerButton = $SummonMenu/Left
@onready var right: PlayerPointerButton = $SummonMenu/Right
@onready var bottom: PlayerPointerButton = $SummonMenu/Bottom

var selected: PlayerPointerButton = null

func _ready() -> void:
	pointer.texture = texture
	menu.hide()
	
func _input(event: InputEvent) -> void:
	pass

func _process(delta: float) -> void:
	var velocity = Input.get_vector("left_traffic", "right_traffic", "up_traffic", "down_traffic") * moveMagnitude
	set_position(position + velocity)
	
	var selection_vel = Input.get_vector("rightJ_left", "rightJ_right", "rightJ_up", "rightJ_down")
	if is_equal_approx(0, selection_vel.length()):
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
		
	# TODO: Handle transition from InRange to Pointing
	if selected != null && Input.is_action_just_pressed("spend_elixir"):
		EventBus.InvokeAbility.emit(selected.ability, selected.cost)

func is_between(val: float, min_val: float, max_val: float) -> bool:
	return val >= min_val and val <= max_val
