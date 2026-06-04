extends TextureRect

@onready var area_2d: Area2D = $Area2D
@onready var ability_timer: Timer = $AbilityOnTimer

@onready var audio_player: RandomAudioPlayer = $RandomAudioPlayer

var device_id: int

func _ready() -> void:
	EventBus.AbilityInvoked.connect(_on_ability_invoked)
	area_2d.monitoring = false
	

func _on_ability_invoked(source_device_id: int, ability: Enums.Ability):
	if ability != Enums.Ability.POLICE or source_device_id != device_id:
		return

	audio_player.play()
	area_2d.monitoring = true
	ability_timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Car:
		var car = body as Car
		car.despawn()
	if body is Bus:
		var bus = body as Bus
		bus.despawn()


func _on_ability_on_timer_timeout() -> void:
	area_2d.monitoring = false
