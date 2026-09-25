extends DirectionalLight2D

class_name Daytime

@export var dawn_color: Color
@export var day_color: Color
@export var dusk_color: Color
@export var night_color: Color

@export var cycle_duration: float = 60.0
@export var fade_duration: float = 5.0

@onready var day_night_timer: Timer = $"../DayNight"

## xdd
var day_state: Enums.DayStates = Enums.DayStates.DAY

func _ready() -> void:
	day_night_timer.timeout.connect(_on_day_night_timeout)
	day_night_timer.wait_time = cycle_duration

func _process(delta: float) -> void:
	Globals.day_state = day_state

func _on_day_night_timeout() -> void:
	day_state = (day_state + 1) % 4
	
	var target_color: Color
	
	if day_state == Enums.DayStates.DAWN:
		target_color = dawn_color
		
	elif day_state == Enums.DayStates.DAY:
		target_color = day_color
		
	elif day_state == Enums.DayStates.DUSK:
		target_color = dusk_color
		
	elif day_state == Enums.DayStates.NIGHT:
		target_color = night_color
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "color", target_color, fade_duration)
	
	print("%d: Changing daytime to: %s" % [day_state, multiplayer.get_unique_id()])
	if Globals.is_multiplayer() and multiplayer.is_server():
		Globals.daytime_changed.rpc(day_state)
	else:
		EventBus.daytime_changed.emit(day_state)
