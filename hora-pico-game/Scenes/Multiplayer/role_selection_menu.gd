extends PanelContainer

class_name  RoleSelectionMenu

@onready var join_police: MainButton = %JoinPolice
@onready var join_traffic: MainButton = %JoinTraffic
@onready var play_btn: MainButton = %Play

@onready var police_container: HBoxContainer = %PoliceContainer
@onready var traffic_container: HBoxContainer = %TrafficContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.RefreshRoleScreen.connect(refresh_screen)
	play_btn.pressed.connect(_on_play_pressed)
	
	join_police.pressed.connect(_on_join_police_pressed)
	join_traffic.pressed.connect(_on_join_traffic_pressed)
	
	play_btn.disabled = not multiplayer.is_server()


func refresh_screen(roles_by_player: Dictionary, textures_by_player: Dictionary) -> void:
	print("%d: Refreshing role menu..." % multiplayer.get_unique_id())
	for child in police_container.get_children():
		child.queue_free()
	for child in traffic_container.get_children():
		child.queue_free()
	
	Network.role_by_player = roles_by_player
	Network.texture_by_player = textures_by_player
	
	for peer_id in roles_by_player:
		var textureNode = TextureRect.new()
		# textureNode.texture = textures[textures_by_player[peer_id]]
		textureNode.texture = ImageTexture.create_from_image(Network.textures[textures_by_player[peer_id]])
		var role = roles_by_player[peer_id]
		
		if role == Enums.Role.TRAFFIC:
			traffic_container.add_child(textureNode)
		elif role == Enums.Role.POLICE:
			police_container.add_child(textureNode)

func _on_play_pressed() -> void:
	if not multiplayer.is_server():
		return
	
	EventBus.DisplayMenu.emit(Enums.Menu.LevelSelectMenu)

func _on_join_police_pressed() -> void:
	Globals.change_role.rpc_id(1, multiplayer.get_unique_id(), Enums.Role.POLICE)
func _on_join_traffic_pressed() -> void:
	Globals.change_role.rpc_id(1, multiplayer.get_unique_id(), Enums.Role.TRAFFIC)
