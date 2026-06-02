extends Node2D

class_name RandomAudioPlayer

@export var audios: Array[AudioStreamPlayer2D]

func _ready() -> void:
	for child in find_children("*", "AudioStreamPlayer2D"):
		audios.append(child)

func play():
	var random = audios.pick_random()
	random.play()
