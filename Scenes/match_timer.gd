extends Label

func _process(delta: float) -> void:
	var minutes: int = $Timer.time_left / 60.0
	var seconds = $Timer.time_left - (minutes*60)
	
	var finalTxt = "Remaining:\n"
	if minutes >= 1:
		finalTxt += "%.0fm" % minutes
	
	finalTxt += " %.0fs" % seconds
	text = finalTxt


func _on_timer_timeout() -> void:
	EventBus.game_ended.emit("City")
