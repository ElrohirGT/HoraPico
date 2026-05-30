extends Control

@export var filling_speed: float
@export var drain_speed: float

@onready var progress_bar: TextureProgressBar = $VBoxContainer/ProgressBar
@onready var remaining_label: Label = $VBoxContainer/RemainingTime

@onready var refresh_progress_bar_timer: Timer = $ProgressBarRefresh
@onready var match_timer: Timer = $MatchTimer

var despawned_vehicles: int = 0
var spawned_vehicles: int = 0
var timer: Timer

func _ready() -> void:
	EventBus.VehicleDespawned.connect(_on_vehicle_despawned)
	EventBus.VehicleSpawned.connect(_on_vehicle_spawned)
	refresh_progress_bar_timer.timeout.connect(_on_refresh_progress_bar)

func _input(event: InputEvent) -> void:
	if event is InputEventMouse && event.is_pressed():
		EventBus.VehicleDespawned.emit()

func _process(delta: float) -> void:
	remaining_label.text = ""
	progress_bar.value -= drain_speed * (despawned_vehicles / 2.0) * delta
	if spawned_vehicles > 0:
		progress_bar.value += filling_speed * delta
	
	var minutes = (int) (match_timer.time_left / 60)
	var seconds = match_timer.time_left - (minutes * 60)
	
	if minutes != 0:
		remaining_label.text = "%dm " % minutes
	
	remaining_label.text += "%ds" % seconds
	
	remaining_label.text

func _on_vehicle_despawned():
	despawned_vehicles += 1
	
func _on_vehicle_spawned():
	spawned_vehicles += 1

func _on_refresh_progress_bar():
	despawned_vehicles = 0
	spawned_vehicles = 0
