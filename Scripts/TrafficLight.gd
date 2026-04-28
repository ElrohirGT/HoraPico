extends StaticBody2D

class_name TrafficLight

@export var remainingSeconds: float = 3.0
@export var isGreen: bool = true # Para decidir si empieza en verde (true) o rojo (false)

@onready var _originalSeconds: float = remainingSeconds

@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label

@onready var sprite: ColorRect = $Red

func _ready() -> void:
	if not isGreen:
		flipCollision()

func flipCollision():
	shape.disabled = !shape.disabled
	if not shape.disabled:
		sprite.color = Color.RED
	else:
		sprite.color = Color.GREEN

func turnRed():
	shape.disabled = false
	sprite.color = Color.RED

func _physics_process(delta: float) -> void:
	remainingSeconds -= delta
	label.text = "Remaining: %.2f" % remainingSeconds
	if remainingSeconds <= 0.0:
		flipCollision()
		remainingSeconds = _originalSeconds

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		print("CLICK!")
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("CLICK! (inside)")
			remainingSeconds = _originalSeconds
			turnRed()
