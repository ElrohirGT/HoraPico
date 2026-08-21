extends DirectionalLight2D

class_name Daytime

@export var day_color: Color
@export var night_color: Color
@export var transition_time: int = 60 # minutos

@onready var day_night_timer: Timer = $"../DayNight"

enum DayStates {
	## Día
	DAY,
	## Noche
	NIGHT
}

## xdd
static var current_state: DayStates = DayStates.DAY

func _ready() -> void:
	pass

func _on_day_night_timeout() -> void:
	current_state = (current_state + 1) % 2
	
	if current_state == DayStates.DAY:
		self.color = day_color
	
	elif current_state == DayStates.NIGHT:
		self.color = night_color
	
	EventBus.daytime_changed.emit(current_state)
