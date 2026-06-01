extends TextureProgressBar

@export var filling_speed: float
@export var drain_speed: float
@export var max_bonus: float

@onready var refresh_progress_bar_timer: Timer = $ProgressBarRefresh

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
	self.value -= (drain_speed + (despawned_vehicles / 2.0)) * delta
	if spawned_vehicles > 0:
		var denominator = despawned_vehicles
		if denominator == 0:
			denominator = 1
		self.value += (filling_speed + denominator) * delta

func _on_vehicle_despawned():
	despawned_vehicles += 1
	
func _on_vehicle_spawned():
	spawned_vehicles += 1

func _on_refresh_progress_bar():
	despawned_vehicles = 0
	spawned_vehicles = 0
