extends Label

var cars_expired = 0

func _ready() -> void:
	EventBus.car_despawned.connect(_on_car_despawned)


func _on_car_despawned() -> void:
	cars_expired += 1

func _on_timer_timeout() -> void:
	var rate = cars_expired / $Timer.wait_time
	text = "RATE:\n%.2f cars/s" % rate
	cars_expired = 0
