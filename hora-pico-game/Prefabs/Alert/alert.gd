extends TextureRect

class_name Alert

@export var display_secs: float
@export var blink_every_n_secs: float

var display_timer: Timer
var blink_timer: Timer

func _ready() -> void:
	display_timer = Timer.new()
	display_timer.autostart = false
	display_timer.wait_time = display_secs
	display_timer.timeout.connect(_on_display_timeout)
	add_child(display_timer)
	
	blink_timer = Timer.new()
	blink_timer.autostart = false
	blink_timer.wait_time = blink_every_n_secs
	blink_timer.timeout.connect(_on_blink_timeout)
	add_child(blink_timer)
	
	self.hide()

func display():
	display_timer.start()
	blink_timer.start()
	
	self.show()

func _on_display_timeout():
	blink_timer.stop()
	self.hide()

func _on_blink_timeout():
	blink_timer.start()
	if self.visible:
		self.hide()
	else:
		self.show()
