extends DirectionalLight2D

class_name Daytime

@export var dawn_color: Color
@export var day_color: Color
@export var dusk_color: Color
@export var night_color: Color

@export_range(0.0, 1.0)
var rain_intensity: float = 0.35

@export var cycle_duration: float = 60.0
@export var fade_duration: float = 5.0

@onready var day_night_timer: Timer = $"../DayNight"

enum DayStates {
	DAWN,
	DAY,
	DUSK,
	NIGHT
}

static var current_state: DayStates = DayStates.DAY


func _ready() -> void:
	day_night_timer.wait_time = cycle_duration
	
	AmbienceManager.day()
	
	_on_weather_changed(WeatherManager.current_weather)
	EventBus.weather_changed.connect(_on_weather_changed)
	
	update_lighting()


func _on_day_night_timeout() -> void:
	current_state = (current_state + 1) % 4
	
	match current_state:
		DayStates.DAWN, DayStates.DAY:
			AmbienceManager.day()
			
		DayStates.DUSK, DayStates.NIGHT:
			AmbienceManager.night()
	
	print("Day time changed to: ", DayStates.keys()[current_state])
	
	update_lighting()
	EventBus.daytime_changed.emit(current_state)


func _on_weather_changed(current_weather: int) -> void:
	if current_weather == WeatherManager.WeatherStates.RAINY:
		AmbienceManager.rain()
	else:
		AmbienceManager.stop_weather()
	
	update_lighting()


func get_day_color() -> Color:
	match current_state:
		DayStates.DAWN:
			return dawn_color
			
		DayStates.DAY:
			return day_color
			
		DayStates.DUSK:
			return dusk_color
			
		DayStates.NIGHT:
			return night_color
	
	return day_color


func get_target_color() -> Color:
	var target := get_day_color()
	
	if WeatherManager.current_weather == WeatherManager.WeatherStates.RAINY:
		target = target.lerp(Color(0.5, 0.55, 0.6), rain_intensity)
	
	return target


func update_lighting() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(
		self,
		"color",
		get_target_color(),
		fade_duration
	)
