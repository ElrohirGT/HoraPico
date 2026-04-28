extends CharacterBody2D

class_name Bus

var movement_speed: float = 75.0
var movement_target_position: Vector2 = Vector2.ZERO
var last_angle: float = 0
var priority: int = 0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: Node2D = $Node2D
@onready var label: Label = $Label

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	await  get_tree().physics_frame
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	actor_setup.call_deferred()
	
	label.text = str(priority)

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
	# sprite.rotation = velocity.angle()
	move_and_slide()
	
func _on_navigation_agent_2d_target_reached() -> void:
	EventBus.car_despawned.emit()
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is Car || body is TrafficLight) && body != self:
		navigation_agent.process_mode = Node.PROCESS_MODE_DISABLED
		movement_speed = 0
		last_angle = rotation
		
		if body is Car or body is Bus:
			var otherCar = body as Car
			if priority < otherCar.priority:
				navigation_agent.process_mode = Node.PROCESS_MODE_ALWAYS
				movement_speed = 100

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body is Car || body is TrafficLight) && body != self:
		navigation_agent.process_mode = Node.PROCESS_MODE_ALWAYS
		movement_speed = 100
