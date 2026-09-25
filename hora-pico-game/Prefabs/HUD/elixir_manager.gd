extends HBoxContainer

class_name ElixirManager

@export var secondsPerElixir: float
@export var maxElixir: float

@onready var elixirBar: TextureProgressBar = $ElixirBar
@onready var elixirLabel: Label = $ElixirLabel

@onready var elixir_plus_player: RandomAudioPlayer = $ElixirPlusAudios
@onready var elixir_alert: Alert = $"../Alert"

@export var elixir_quantity: float
var elixirTimer: Timer

func _ready() -> void:
	EventBus.AbilityInvoked.connect(_on_ability_invoked)

	elixirTimer = Timer.new()
	elixirTimer.wait_time = secondsPerElixir
	elixirTimer.autostart = true
	elixirTimer.timeout.connect(generateElixir)
	add_child(elixirTimer)

	elixirBar.max_value = maxElixir

	EventBus.InvokeAbility.connect(_on_invoke_ability)

func generateElixir():
	elixir_quantity = clampf(elixir_quantity+1, 0, maxElixir)
	updateElixir(elixir_quantity)

func _process(delta: float) -> void:
	Globals.elixir_quantity = elixir_quantity
	var remaining = (elixirTimer.wait_time - elixirTimer.time_left) / elixirTimer.wait_time
	updateElixir(clampf(elixir_quantity+remaining, 0, maxElixir))

func updateElixir(quantity: float):
	elixirBar.value = quantity
	elixirLabel.text = "%d" % quantity

func ConsumeElixir(quantity: float) -> bool:
	if elixir_quantity-quantity < 0:
		return false

	elixir_quantity -= quantity
	EventBus.ElixirChanged.emit(elixir_quantity)
	return true

func _on_invoke_ability(source_device_id: int, ability: Enums.Ability, cost: float):
	if not ConsumeElixir(cost):
		print("Failed to consume ability: %s" % ability)
		return
	print("Ability %s consumed by %d!" % [ability, source_device_id])
	EventBus.AbilityInvoked.emit(source_device_id, ability)

func _on_ability_invoked(source_device_id: int, ability: Enums.Ability):
	if ability != Enums.Ability.ELIXIR:
		return

	elixir_alert.display()
	elixir_plus_player.play()
	maxElixir += 1
	elixirBar.max_value = maxElixir
