extends Area2D

class_name BusStop

@onready var bus_stop_timer: Timer = $BusStopTimer
@onready var bus_stop_collision: CollisionShape2D = $CollisionShape2D

var current_bus: CharacterBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_bus_stop_timer_timeout() -> void:
	print("Activado")
	bus_stop_collision.show()

func _on_body_entered(body: CharacterBody2D) -> void:
	if body is Bus:
		current_bus = body
		body.is_waiting = true
		bus_stop_collision.hide()

func _on_body_exited(body: CharacterBody2D) -> void:
	if body is Bus:
		if body == current_bus:
			bus_stop_collision.show()
