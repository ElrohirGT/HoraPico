extends Node2D

class_name Lobby

@export var role_by_player = {}
@export var texture_by_player = {}

var textures = [
	Image.load_from_file("res://TestSprites/PLAYER_P1.png"),
	Image.load_from_file("res://TestSprites/PLAYER_P2.png"),
	Image.load_from_file("res://TestSprites/PLAYER_P3.png")
]

@onready var role_selection_menu: RoleSelectionMenu = %RoleSelectionMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.PlayerJoining.connect(_on_player_joined)
	EventBus.ChangeRole.connect(_on_player_change_role)

func _on_player_joined(peer_id: int):
	texture_by_player[peer_id] = ImageTexture.create_from_image(textures[len(role_by_player) % len(textures)])
	role_by_player[peer_id] = Enums.Role.TRAFFIC
	if is_traffic_greater_than_one():
		role_by_player[peer_id] = Enums.Role.POLICE
	
	print("Added new player %d as %s" % [peer_id, role_by_player[peer_id]])
	if multiplayer.is_server():
		print("I'M SERVER")
		refresh_ui.rpc(role_by_player, texture_by_player)

func _on_player_change_role(peer_id: int, role: Enums.Role):
	print("Changed role for %d into %s" % [peer_id, role])
	role_by_player[peer_id] = role
	if multiplayer.is_server():
		print("I'M SERVER")
		refresh_ui.rpc(role_by_player, texture_by_player)

func is_traffic_greater_than_one() -> bool:
	var count = 0
	for peer_id in role_by_player:
		if role_by_player[peer_id] == Enums.Role.TRAFFIC:
			count+=1
	return count > 1

@rpc("authority", "call_local")
func refresh_ui(roles, tex):
	role_selection_menu.refresh_screen(roles, tex)
