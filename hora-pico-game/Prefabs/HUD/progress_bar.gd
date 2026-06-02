extends TextureProgressBar

@export var drain_speed: float
@export var max_bonus: float

@onready var refresh_progress_bar_timer: Timer = $ProgressBarRefresh
@onready var bar_label: Label = $Info
@onready var chaos_display: Label = $ChaosDisplay
@onready var chaos_timer: Timer = $ChaosTimer

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
	var alive_vehicles = spawned_vehicles - despawned_vehicles
	if alive_vehicles == 0:
		alive_vehicles = 1.0
	var bar_delta = - (drain_speed + (1/alive_vehicles)) * delta
	if spawned_vehicles > 0:
		bar_delta += alive_vehicles * delta
	
	bar_label.text = "S: %d - D: %d - T: %.2f" % [spawned_vehicles, despawned_vehicles, bar_delta]
	self.value += bar_delta
	
	if self.value >= self.max_value and chaos_timer.is_stopped():
		chaos_timer.start()
		chaos_display.show()
	if self.value < self.max_value:
		chaos_timer.stop()
		chaos_display.hide()
	
	if not chaos_timer.is_stopped():
		chaos_display.text = "%.2fs" % chaos_timer.time_left

func _on_vehicle_despawned():
	despawned_vehicles += 1
	
func _on_vehicle_spawned():
	spawned_vehicles += 1

func _on_refresh_progress_bar():
	despawned_vehicles = 0
	spawned_vehicles = 0


func _on_chaos_timer_timeout() -> void:
	EventBus.GameEnded.emit("Traffic")
