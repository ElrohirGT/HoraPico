extends Node2D


@export var id: String
@export var destinations: Array[Node2D]

func _on_spawn(spawner_id: String, obj: Node2D):
	if id != spawner_id:
		return
	
	
