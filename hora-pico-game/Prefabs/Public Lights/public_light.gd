extends Node2D

@onready var lights: Array = [$PointLight2D, $PointLight2D2, $PointLight2D3]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.daytime_changed.connect(_on_daytime_changed)
	
	toggle_lights(Daytime.current_state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func toggle_lights(current_daytime: int) -> void:
	var target_energy: float = 0.0
	
	if current_daytime == 1:
		target_energy = 0.0
	
	elif current_daytime in [2, 3]:
		target_energy = 1.0
	
	var tween := create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	for light in lights:
		tween.tween_property(light, "energy", target_energy, 0.5)

func _on_daytime_changed(current_daytime: int) -> void:
	toggle_lights(current_daytime)
