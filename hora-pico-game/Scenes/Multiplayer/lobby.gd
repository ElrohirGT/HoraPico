extends Control

@onready var room_id: Label = %RoomId
@onready var copy: MainButton = %Copy
@onready var exit: MainButton = %Exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_id.text = Network.tube_client.session_id

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
