extends Node

@onready var ambience_player: AudioStreamPlayer = $AmbiencePlayer

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
	ambience_player.stream = rain_sound
	ambience_player.play()

func adjust_volume(volume: float) -> void:
	ambience_player.volume_db = volume
