extends Area2D

class_name Alert


func _on_body_entered(body: Node2D) -> void:
	print("Colliding with: ", body)
