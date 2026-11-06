extends GridContainer

@onready var top: PlayerPointerButton = $Top
@onready var left: PlayerPointerButton = $Left
@onready var right: PlayerPointerButton = $Right
@onready var bottom: PlayerPointerButton = $Bottom

func _input(event: InputEvent) -> void:
	if event.is_action("top_police"):
		EventBus.InvokeAbility.emit(event.device, top.ability, top.cost)
	elif event.is_action("bottom_police"):
		EventBus.InvokeAbility.emit(event.device, bottom.ability, bottom.cost)
	elif event.is_action("right_police"):
		EventBus.InvokeAbility.emit(event.device, right.ability, right.cost)
	elif event.is_action("left_police"):
		EventBus.InvokeAbility.emit(event.device, left.ability, left.cost)
