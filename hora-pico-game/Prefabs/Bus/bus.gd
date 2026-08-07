extends CharacterBody2D

class_name Bus

@export var original_movement_speed: float = 60.0
@export var turbo_speed: float = 100.0

var is_waiting: bool = false

var default_movement_speed: float = original_movement_speed
var movement_speed: float = original_movement_speed
var movement_target_position: Vector2 = Vector2.ZERO
var last_angle: float = 0
var priority: int = 0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var bus_waiting_timer: Timer = $BusWaitTimer

var sprites: Array[Sprite2D]

func _ready():
	EventBus.AbilityInvoked.connect(_on_ability_invoked)
	EventBus.SpeedEnded.connect(_on_speed_ended)

	var sp = find_children("Bus*", "Sprite2D").map(func(el): return (el as Sprite2D))
	sprites.assign(sp)

	for variant in sprites:
		variant.hide()
	sprites.pick_random().show()
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func _process(delta: float) -> void:
	if is_waiting:
		is_waiting = false
		navigation_agent.process_mode = Node.PROCESS_MODE_DISABLED
		movement_speed = 0
		last_angle = rotation
		bus_waiting_timer.start()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	rotation = velocity.angle()
	if velocity == Vector2.ZERO:
		rotation = last_angle
	move_and_slide()

func _on_navigation_agent_2d_navigation_finished() -> void:
	despawn()

func despawn():
	EventBus.VehicleDespawned.emit()
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is Car || body is TrafficLight || body is Bus) && body != self:
		navigation_agent.process_mode = Node.PROCESS_MODE_DISABLED
		movement_speed = 0
		last_angle = rotation

		if body is Car:
			var otherCar = body as Car
			if priority < otherCar.priority:
				navigation_agent.process_mode = Node.PROCESS_MODE_ALWAYS
				movement_speed = default_movement_speed

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body is Car || body is TrafficLight || body is Bus) && body != self:
		navigation_agent.process_mode = Node.PROCESS_MODE_ALWAYS
		movement_speed = default_movement_speed

func _on_ability_invoked(source_device_id: int, ability: Enums.Ability):
	if ability == Enums.Ability.SPEED:
		default_movement_speed = turbo_speed
		movement_speed = turbo_speed

func _on_speed_ended():
	default_movement_speed = original_movement_speed
	movement_speed = original_movement_speed

func _on_bus_wait_timer_timeout() -> void:
	navigation_agent.process_mode = Node.PROCESS_MODE_ALWAYS
	movement_speed = default_movement_speed
