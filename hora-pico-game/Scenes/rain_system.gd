extends Node

@onready var particles: GPUParticles2D = $GPUParticles2D



func _ready() -> void:
	EventBus.weather_changed.connect(_on_weather_changed)
	_on_weather_changed(WeatherManager.current_weather)

func _on_weather_changed(weather: WeatherManager.WeatherStates) -> void:
	print("Forecast: ", WeatherManager.WeatherStates.keys()[weather])
	# Switch at home
	match weather:
		WeatherManager.WeatherStates.RAINY:
			_start_rain()
			
		WeatherManager.WeatherStates.SUNNY:
			_stop_rain()

func _start_rain() -> void:
	print("Make it rain!")
	particles.emitting = true
	
	var tween := create_tween()
	tween.tween_property(particles, "amount_ratio", 1.0, 3.0)

func _stop_rain() -> void:
	print("Make it stop")
	var tween := create_tween()
	tween.tween_property(particles, "amount_ratio", 0.0, 3.0)
	
	await tween.finished
	
	particles.emitting = false
