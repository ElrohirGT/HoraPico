extends TextureRect

@onready var timer: Timer = $DisplayTimer

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func display():
	self.show()
	timer.start()

func _on_timer_timeout():
	self.hide()
