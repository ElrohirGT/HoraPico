extends Node

@onready var ambience_player: AudioStreamPlayer = $"/root/AmbienceManager/AmbiencePlayer"
@onready var weather_player: AudioStreamPlayer = $"/root/AmbienceManager/WeatherPlayer"

const day_sound: AudioStream = preload("res://Audio/Effects/SFX/day.mp3")
const night_sound: AudioStream = preload("res://Audio/Effects/SFX/night.mp3")
const rain_sound: AudioStream = preload("res://Audio/Effects/SFX/rain.mp3")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func day() -> void:
	ambience_player.stream = day_sound
	ambience_player.play()

func night() -> void:
	ambience_player.stream = night_sound
	ambience_player.play()

func rain() -> void:
	weather_player.stream = rain_sound
	weather_player.play()
	
func stop_weather() -> void:
	weather_player.stop()

func adjust_volume(volume: float) -> void:
	ambience_player.volume_db = volume

func _on_ambience_player_finished() -> void:
	pass # Replace with function body.
