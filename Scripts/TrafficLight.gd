extends StaticBody2D

@export var remainingSeconds: float = 3.0
@export var initialColor: bool = true # Para decidir si empieza en verde (true) o rojo (false)

@onready var _originalSeconds: float = remainingSeconds

@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label

@onready var sprite: ColorRect = $Red

func _ready() -> void:
	if not initialColor:
		flipCollision()

func flipCollision():
	shape.disabled = !shape.disabled
	if not shape.disabled:
		sprite.color = Color.RED
	else:
		sprite.color = Color.GREEN

func _physics_process(delta: float) -> void:
	remainingSeconds -= delta
	label.text = "Remaining: %.2f" % remainingSeconds
	if remainingSeconds <= 0.0:
		flipCollision()
		remainingSeconds = _originalSeconds
