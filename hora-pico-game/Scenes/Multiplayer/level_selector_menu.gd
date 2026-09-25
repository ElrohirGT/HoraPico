extends PanelContainer

@onready var nivel_1: MainButton = %Nivel1
@onready var nivel_2: MainButton = %Nivel2
@onready var nivel_3: MainButton = %Nivel3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nivel_1.disabled = not multiplayer.is_server()
	nivel_2.disabled = not multiplayer.is_server()
	nivel_3.disabled = not multiplayer.is_server()
	
	nivel_1.pressed.connect(func (): load_level.rpc(0))
	nivel_2.pressed.connect(func (): load_level.rpc(1))
	nivel_3.pressed.connect(func (): load_level.rpc(2))

@rpc("authority", "call_local")
func load_level(idx: int):
	var level = "res://Scenes/Multiplayer/Levels/Level%d.tscn" % idx
	print("%d: Loading level: %s" % [multiplayer.get_unique_id(), level])
	get_tree().change_scene_to_file(level)
