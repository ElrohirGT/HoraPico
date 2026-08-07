extends Control

@export var pointer_textures: Array[Texture2D]

@onready var play: Button = $Panel/HFlowContainer/Play
@onready var back: Button = $Panel/HFlowContainer/Back

@onready var traffic = $Panel/HFlowContainer/VBoxContainer/TrafficContainer
@onready var police = $Panel/HFlowContainer/VBoxContainer2/PoliceContainer

@onready var level_selector = $LevelSelector
@onready var role_menu = $Panel

func _ready() -> void:
	EventBus.DeviceConnected.connect(refresh_screen)
	EventBus.DeviceDisconnected.connect(refresh_screen)
	EventBus.ChangedRole.connect(refresh_screen)
	EventBus.DisplayMenu.connect(_hide_show_menu)
	
	play.text = "[%s] Play" % Utils.get_key_or_button_for_action("ui_accept")
	back.text = "[%s] Quit" % Utils.get_key_or_button_for_action("ui_select")
	
	refresh_screen()
	
func _hide_show_menu(id: Enums.Menu):
	if id == Enums.Menu.RoleMenu:
		self.show()
		refresh_screen()
	else:
		self.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up_traffic") or event.is_action_pressed("light_up"):
		EventBus.ChangeRole.emit(event.device, Enums.Role.TRAFFIC)
	elif event.is_action_pressed("down_traffic") or event.is_action_pressed("light_down"):
		EventBus.ChangeRole.emit(event.device, Enums.Role.POLICE)
	elif event.is_action_pressed("ui_accept") and not play.disabled:
		EventBus.DisplayMenu.emit(Enums.Menu.LevelSelectMenu)
	elif event.is_action_pressed("ui_select"):
		EventBus.DisplayMenu.emit(Enums.Menu.MainMenu)
	refresh_screen()

func _process(delta: float) -> void:
	var trafficCount = 0
	var policeCount = 0
	
	for device in InputManager.role_by_device:
		if InputManager.role_by_device[device] == Enums.Role.POLICE:
			policeCount += 1
		else:
			trafficCount += 1
	
	if trafficCount > 0 and trafficCount < 2 and policeCount > 0 and policeCount < 3:
		play.disabled = false

func refresh_screen():
	print("refresh_screen called, dict = ", InputManager.role_by_device)
	
	# Free all children
	for child in traffic.get_children():
		child.queue_free()
	for child in police.get_children():
		child.queue_free()
		
	for device in InputManager.role_by_device:
		var textureNode = TextureRect.new()
		textureNode.texture = pointer_textures[device % len(pointer_textures)]
		var role = InputManager.role_by_device[device]
		
		print("Assigning ", device, " to ", role)
		if role == Enums.Role.TRAFFIC:
			traffic.add_child(textureNode)
		elif role == Enums.Role.POLICE:
			police.add_child(textureNode)
