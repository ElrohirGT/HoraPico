extends Control

enum PointerState {POINTING, IN_RANGE, SUMMONING}

@export var moveMagnitude: float
@export var texture: Texture2D

@onready var pointer: TextureRect = $Pointer
@onready var menu: Control = $SummonMenu

var state = PointerState.POINTING

func _ready() -> void:
	pointer.texture = texture
	menu.hide()
	
func _input(event: InputEvent) -> void:
	pass

func _process(delta: float) -> void:
	var velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * moveMagnitude
	set_position(position + velocity)
	
	if Input.is_action_pressed("ui_accept"):
		state = PointerState.IN_RANGE
	else:
		state = PointerState.POINTING
	
	if state == PointerState.IN_RANGE:
		menu.show()
	else:
		menu.hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Collision!")
	if body is Alert:
		print("Displaying menu!")
		state = PointerState.IN_RANGE
	
