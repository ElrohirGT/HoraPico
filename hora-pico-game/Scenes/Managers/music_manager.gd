extends Node

@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer

const main_menu_loop: AudioStream = preload("res://Audio/Hora_Pico.wav")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func play() -> void:
	music_player.stream = main_menu_loop
	music_player.play()

func stop() -> void:
	music_player.stop()

func adjust_volume(volume: float) -> void:
	music_player.volume_db = volume

func _on_ambience_player_finished() -> void:
	pass # Replace with function body.
