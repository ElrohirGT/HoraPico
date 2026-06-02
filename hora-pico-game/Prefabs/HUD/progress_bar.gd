extends TextureProgressBar

@export var filling_speed: float
@export var drain_speed: float
@export var max_bonus: float

@onready var refresh_progress_bar_timer: Timer = $ProgressBarRefresh
@onready var bar_label: Label = $Label

var despawned_vehicles: int = 0
var spawned_vehicles: int = 0

func _ready() -> void:
	EventBus.VehicleDespawned.connect(_on_vehicle_despawned)
	EventBus.VehicleSpawned.connect(_on_vehicle_spawned)
	refresh_progress_bar_timer.timeout.connect(_on_refresh_progress_bar)

func _input(event: InputEvent) -> void:
	if event is InputEventMouse && event.is_pressed():
		EventBus.VehicleDespawned.emit()

func _process(delta: float) -> void:
	var bar_delta = - (drain_speed + (despawned_vehicles / 2.0)) * delta
	if spawned_vehicles > 0:
		var denominator = despawned_vehicles
		if denominator == 0:
			denominator = 1
		bar_delta += (filling_speed + denominator) * delta
	
	bar_label.text = "S: %d - D: %d - T: %.2f" % [spawned_vehicles, despawned_vehicles, bar_delta]
	self.value += bar_delta

func _on_vehicle_despawned():
	despawned_vehicles += 1
	
func _on_vehicle_spawned():
	spawned_vehicles += 1

func _on_refresh_progress_bar():
	despawned_vehicles = 0
	spawned_vehicles = 0
