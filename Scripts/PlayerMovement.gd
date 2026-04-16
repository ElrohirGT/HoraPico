extends CharacterBody2D

@export var player_id: int = 0 # Número de jugador
@export var deadzone: float = 0.4

@onready var collision = $CollisionShape2D

const _speed: float = 400.0

const _colors = [Color.BLUE, Color.RED, Color.GREEN]

func _ready() -> void:
	collision.debug_color = _colors[player_id % 3]

func _physics_process(delta: float) -> void:
	print(delta)
	
	var X = Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X)
	var Y = Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y)

	var magnitude: Vector2 = Vector2(X, Y)

	if magnitude.length() < deadzone:
		velocity = Vector2.ZERO

	else:
		velocity = magnitude * _speed
		
	move_and_slide() 
