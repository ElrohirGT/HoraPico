extends Node2D

@onready var lights: Array = [$PointLight2D, $PointLight2D2, $PointLight2D3]
@onready var timer: Timer = %EventTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.daytime_changed.connect(_on_daytime_changed)
	timer.timeout.connect(_on_timer_timeout)
	
	toggle_lights(Daytime.current_state)
	# toggle_lights(Daytime.DayStates.NIGHT) # Testing purposes!


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func toggle_lights(current_daytime: int) -> void:
	var target_energy: float = 0.0
	
	if current_daytime == 1:
		target_energy = 0.0
	
	elif current_daytime in [2, 3]:
		target_energy = 1.0
		timer.start()
	
	var tween := create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	for light in lights:
		tween.tween_property(light, "energy", target_energy, 0.5)

func _on_daytime_changed(current_daytime: int) -> void:
	toggle_lights(current_daytime)

func blink(seconds: Array):
	for s in seconds:
		for light in lights:
				light.energy = 0
		await get_tree().create_timer(s).timeout
		for light in lights:
			light.energy = 1
		await get_tree().create_timer(0.05).timeout

func _on_timer_timeout():
	if Daytime.current_state in [0,1]:
		return
	
	var rnumber = randi() % 10
	# if rnumber > -1: # 100% chance
	if rnumber > 6: # 33% chance
		var blink_patterns: Array[Array] = [
			[0.4, 0.1, 0.1],
			[0.1, 0.1, 0.1],
			[0.1, 0.1, 0.5],
			[0.2, 0.2, 0.2],
			[0.3, 0.4, 0]
		]
		blink(blink_patterns.pick_random())
	
	timer.start()
