extends StaticBody2D

class_name TrafficLight

enum TrafficLightState{RED, YELLOW, GREEN, HACKED}

@onready var Red: Sprite2D = $Red
@onready var Yellow: Sprite2D = $Yellow
@onready var Green: Sprite2D = $Green
@onready var Hacked: Sprite2D = $Hacked
@onready var Collider: CollisionShape2D = $CollisionShape2D

@export var cycleDuration: float
@export var yellowPercentage: float
@export var state: TrafficLightState

var timer: Timer
var is_cursor_hovering: bool = false

func updateVisually():
	Red.hide()
	Yellow.hide()
	Green.hide()
	Hacked.hide()
	
	if state == TrafficLightState.RED:
		Red.show()
		Collider.set_deferred("disabled", false)
	elif state == TrafficLightState.YELLOW:
		Yellow.show()
		Collider.set_deferred("disabled", true)
	elif state == TrafficLightState.GREEN:
		Green.show()
		Collider.set_deferred("disabled", true)
	elif state == TrafficLightState.HACKED:
		Hacked.show()
		Collider.set_deferred("disabled", false)

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = cycleDuration
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	
	timer.start()

func _on_timer_timeout() -> void:
	# print("Timer done!")
	if state == TrafficLightState.RED:
		state = TrafficLightState.GREEN
	elif state == TrafficLightState.GREEN or state == TrafficLightState.YELLOW:
		state = TrafficLightState.RED
	
	timer.start()

func _process(delta: float) -> void:
	if state == TrafficLightState.GREEN:
		if timer.time_left <= timer.wait_time * yellowPercentage:
			state = TrafficLightState.YELLOW
	updateVisually()

func _on_interact_area_area_entered(area: Area2D) -> void:
	if area.owner is TrafficPlayerPointer:
		is_cursor_hovering = true

func _on_interact_area_area_exited(area: Area2D) -> void:
	if area.owner is TrafficPlayerPointer:
		is_cursor_hovering = false
		
func _unhandled_input(event: InputEvent) -> void:
	if is_cursor_hovering and event.is_action_pressed("hack_traffic"):
		hack_traffic_light()
		
func hack_traffic_light() -> void:
	if state != TrafficLightState.HACKED:
		state = TrafficLightState.HACKED
		timer.stop()

func unhack_traffic_light() ->void:
	state = TrafficLightState.GREEN
	timer.start()
