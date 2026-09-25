extends Panel

@export var neutral_arrow: Texture2D
@export var correct_arrow: Texture2D
@export var wrong_arrow: Texture2D
@export var device_id: int

@onready var container: HBoxContainer = $HBoxContainer
@onready var mistake_timer: Timer = $MistakeDisplayTimer

@onready var display_audio_player: RandomAudioPlayer = $DisplayAudios
@onready var failure_audio_player: RandomAudioPlayer = $FailureAudios
@onready var success_audio_player: RandomAudioPlayer = $SuccessAudios

enum Directions{UP, DOWN, LEFT, RIGHT}
var done: Array[Directions]
var pattern: Array[Directions]
var selected_traffic_light: TrafficLight

func _ready() -> void:
	EventBus.AbilityInvoked.connect(_on_ability_invoked)
	self.hide()

func _input(event: InputEvent) -> void:
	if not event.is_pressed() or event.is_echo() or event.device != device_id:
		return

	var idx = len(done)
	if idx >= len(pattern):
		return

	var expected = pattern[idx]

	var dir: Directions
	if event.is_action_pressed("light_up"):
		dir = Directions.UP
	elif event.is_action_pressed("light_down"):
		dir = Directions.DOWN
	elif event.is_action_pressed("light_left"):
		dir = Directions.LEFT
	elif event.is_action_pressed("light_right"):
		dir = Directions.RIGHT
	else:
		return

	if dir != expected:
		if mistake_timer.is_stopped():
			failure_audio_player.play()
			mistake_timer.start()

	if dir == expected and idx+1 == len(pattern) and mistake_timer.is_stopped():
		success_audio_player.play()
		call_deferred("_on_pattern_complete")

	done.append(dir)

func _on_pattern_mistake():
	self.hide()
	done = []

func _on_pattern_complete():
	self.hide()
	done = []
	if selected_traffic_light != null:
		selected_traffic_light.unhack_traffic_light()

func _on_ability_invoked(source_device_id: int, ability: Enums.Ability):
	if ability != Enums.Ability.FIX_TRAFFIC_LIGHT or source_device_id != device_id:
		print("Ignoring ability: %d - src: %d - own: %d" % [ability, source_device_id, device_id])
		return

	display_audio_player.play()
	pattern = generate_random_pattern()
	self.show()

func _process(delta: float) -> void:
	for child in container.get_children():
		child.queue_free()

	for idx in pattern.size():
		var p = pattern[idx]
		var texture_container = Control.new()
		texture_container.custom_minimum_size = Vector2(16, 16)
		var texture = TextureRect.new()
		texture.set_anchors_preset(Control.PRESET_FULL_RECT)
		texture.pivot_offset_ratio = Vector2(0.5, 0.5)
		texture.texture = neutral_arrow
		if p == Directions.DOWN:
			texture.rotation_degrees = 180
		if p == Directions.RIGHT:
			texture.rotation_degrees = 90
		if p == Directions.LEFT:
			texture.rotation_degrees = -90

		if idx < done.size():
			var selected = done[idx]
			if selected != p:
				texture.texture = wrong_arrow
			else:
				texture.texture = correct_arrow

		texture_container.add_child(texture)
		container.add_child(texture_container)

func generate_random_pattern() -> Array[Directions]:
	var directions = [Directions.UP, Directions.DOWN, Directions.LEFT, Directions.RIGHT]
	var new_pattern: Array[Directions]
	var length = randi_range(3, 5)

	for i in length:
		new_pattern.append(directions.pick_random())
	return new_pattern


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is TrafficLight:
		selected_traffic_light = body


func _on_mistake_display_timer_timeout() -> void:
	call_deferred("_on_pattern_mistake")
