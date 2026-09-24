extends PanelContainer

class_name  RoleSelectionMenu

var textures = [
	Image.load_from_file("res://TestSprites/PLAYER_P1.png"),
	Image.load_from_file("res://TestSprites/PLAYER_P2.png"),
	Image.load_from_file("res://TestSprites/PLAYER_P3.png")
]

@onready var join_police: MainButton = %JoinPolice
@onready var join_traffic: MainButton = %JoinTraffic
@onready var play_btn: MainButton = %Play
@onready var ready_btn: MainButton = %Ready

@onready var police_container: HFlowContainer = %PoliceContainer
@onready var traffic_container: HFlowContainer = %TrafficContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_btn.pressed.connect(_on_play_pressed)
	ready_btn.pressed.connect(_on_ready_pressed)
	
	join_police.pressed.connect(_on_join_police_pressed)
	join_traffic.pressed.connect(_on_join_traffic_pressed)
	
	play_btn.disabled = not multiplayer.is_server()

func refresh_screen(roles_by_player: Dictionary, textures_by_player: Dictionary) -> void:
	print("%d: Refreshing role menu..." % multiplayer.get_unique_id())
	for child in police_container.get_children():
		child.queue_free()
	for child in traffic_container.get_children():
		child.queue_free()
	
	for peer_id in roles_by_player:
		var textureNode = TextureRect.new()
		#textureNode.texture = textures[textures_by_player[peer_id]]
		textureNode.texture = ImageTexture.create_from_image(textures[textures_by_player[peer_id]])
		var role = roles_by_player[peer_id]
		
		if role == Enums.Role.TRAFFIC:
			traffic_container.add_child(textureNode)
		elif role == Enums.Role.POLICE:
			police_container.add_child(textureNode)

func _on_play_pressed() -> void:
	pass # Navigate to LevelSelector
func _on_ready_pressed() -> void:
	pass # Send MSG of ready

func _on_join_police_pressed() -> void:
	Globals.change_role.rpc_id(1, multiplayer.get_unique_id(), Enums.Role.POLICE)
func _on_join_traffic_pressed() -> void:
	Globals.change_role.rpc_id(1, multiplayer.get_unique_id(), Enums.Role.TRAFFIC)
