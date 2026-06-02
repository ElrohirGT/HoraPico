extends TextureProgressBar

@onready var timer = $SpeedAbilityTimer
@onready var speed_sounds_player: RandomAudioPlayer = $SpeedSounds

func _ready() -> void:
	EventBus.AbilityInvoked.connect(_on_ability_invoked)
	self.hide()

func _process(delta: float) -> void:
	self.value = timer.time_left / timer.wait_time

func _on_ability_invoked(ability: Enums.Ability):
	if ability != Enums.Ability.SPEED:
		return
	
	speed_sounds_player.play()
	timer.start()
	self.show()

func _on_speed_ability_timer_timeout() -> void:
	self.hide()
	EventBus.SpeedEnded.emit()
