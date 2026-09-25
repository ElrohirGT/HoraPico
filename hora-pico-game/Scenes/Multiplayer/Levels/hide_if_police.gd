extends CanvasItem


func _ready() -> void:
	if Globals.is_police():
		self.hide()
		set_process(false)
		set_process_input(false)
