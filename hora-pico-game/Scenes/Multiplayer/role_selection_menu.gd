extends PanelContainer

@onready var join_police: MainButton = %JoinPolice
@onready var join_traffic: MainButton = %JoinTraffic
@onready var play_btn: MainButton = %Play
@onready var ready_btn: MainButton = %Ready

@onready var police_container: HFlowContainer = %PoliceContainer
@onready var traffic_container: HFlowContainer = %TrafficContainer

@onready var lobby: Lobby = $"../../../.."
# @onready var role_syncronizer: MultiplayerSynchronizer = %RoleSyncronizer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.connected_to_server.connect(func (_arg): refresh_screen())
	multiplayer.peer_connected.connect(func (_arg): refresh_screen())
	multiplayer.peer_disconnected.connect(func (_arg): refresh_screen())
	EventBus.PlayerJoined.connect(func(_arg): refresh_screen())
	EventBus.ChangedRole.connect(func(_arg1, _arg2): refresh_screen())
	
	# role_syncronizer.delta_synchronized.connect(refresh_screen)
	# role_syncronizer.synchronized.connect(refresh_screen)
	
	play_btn.pressed.connect(_on_play_pressed)
	ready_btn.pressed.connect(_on_ready_pressed)
	
	join_police.pressed.connect(_on_join_police_pressed)
	join_traffic.pressed.connect(_on_join_traffic_pressed)
	
	if not multiplayer.is_server():
		play_btn.disabled = true
	
	# refresh_screen()

func refresh_screen() -> void:
	print("Refreshing role menu...")
	for child in police_container.get_children():
		child.queue_free()
	for child in traffic_container.get_children():
		child.queue_free()
	
	var roles_by_player = lobby.role_by_player
	
	for peer_id in roles_by_player:
		var textureNode = TextureRect.new()
		textureNode.texture = lobby.texture_by_player[peer_id]
		var role = roles_by_player[peer_id]
		
		if role == Enums.Role.TRAFFIC:
			traffic_container.add_child(textureNode)
		elif role == Enums.Role.POLICE:
			police_container.add_child(textureNode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	refresh_screen()

func _on_play_pressed() -> void:
	pass # Navigate to LevelSelector
func _on_ready_pressed() -> void:
	pass # Send MSG of ready

func _on_join_police_pressed() -> void:
	Globals.change_role.rpc_id(1, multiplayer.get_unique_id(), Enums.Role.POLICE)
func _on_join_traffic_pressed() -> void:
	Globals.change_role.rpc_id(1, multiplayer.get_unique_id(), Enums.Role.TRAFFIC)
