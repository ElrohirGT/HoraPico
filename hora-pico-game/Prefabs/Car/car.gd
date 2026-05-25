extends CharacterBody2D

@export var movement_speed: float = 200.0
@export var target: Node2D

@export var path_desired_distance: float = 0.1
@export var target_desired_distance: float = 0.2

@onready var agent: NavigationAgent2D = $NavigationAgent2D
var sprites: Array[Sprite2D]

func _ready():
	var sp = find_children("Car*", "Sprite2D").map(func(el): return (el as Sprite2D))
	sprites.assign(sp)
	
	for variant in sprites:
		variant.hide()
	sprites.pick_random().show()
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	agent.path_desired_distance = path_desired_distance
	agent.target_desired_distance = target_desired_distance

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	agent.target_position = target.position

func _physics_process(delta):
	if agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
