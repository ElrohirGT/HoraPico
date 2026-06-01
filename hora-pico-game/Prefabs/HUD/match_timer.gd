extends Label

@onready var match_timer: Timer = $MatchTimer

func _ready() -> void:
	self.text = ""

func _process(delta: float) -> void:
	var minutes: int = match_timer.time_left / 60
	var seconds: int = match_timer.time_left - minutes * 60
	
	if not is_zero_approx(minutes):
		self.text = "%dm %ds" % [minutes, seconds]
	else:
		self.text = "%ds" % seconds
