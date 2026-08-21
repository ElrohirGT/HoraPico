extends DirectionalLight2D

class_name Daytime

@export var dawn_color: Color
@export var day_color: Color
@export var dusk_color: Color
@export var night_color: Color

@export var cycle_duration: float = 60.0
@export var fade_duration: float = 5.0

@onready var day_night_timer: Timer = $"../DayNight"

enum DayStates {
	## Alba
	DAWN,
	## Día
	DAY,
	## Ocaso
	DUSK,
	## Noche
	NIGHT
}

## xdd
static var current_state: DayStates = DayStates.DAY

func _ready() -> void:
	day_night_timer.wait_time = cycle_duration

func _on_day_night_timeout() -> void:
	current_state = (current_state + 1) % 4
	
	var target_color: Color
	
	if current_state == DayStates.DAWN:
		target_color = dawn_color
		
	elif current_state == DayStates.DAY:
		target_color = day_color
		
	elif current_state == DayStates.DUSK:
		target_color = dusk_color
		
	elif current_state == DayStates.NIGHT:
		target_color = night_color
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "color", target_color, fade_duration)

	EventBus.daytime_changed.emit(current_state)
