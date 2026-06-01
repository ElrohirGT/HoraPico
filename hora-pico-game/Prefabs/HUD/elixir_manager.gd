extends HBoxContainer

class_name ElixirManager

@export var secondsPerElixir: float
@export var maxElixir: float

@onready var elixirBar: TextureProgressBar = $ElixirBar
@onready var elixirLabel: Label = $ElixirLabel

static var elixirQuantity: float
var elixirTimer: Timer

func _ready() -> void:
	elixirTimer = Timer.new()
	elixirTimer.wait_time = secondsPerElixir
	elixirTimer.autostart = true
	elixirTimer.timeout.connect(generateElixir)
	add_child(elixirTimer)
	
	elixirBar.max_value = maxElixir
	
	EventBus.InvokeAbility.connect(_on_invoke_ability)

func generateElixir():
	elixirQuantity = clampf(elixirQuantity+1, 0, maxElixir)
	updateElixir(elixirQuantity)

func _process(delta: float) -> void:
	var remaining = (elixirTimer.wait_time - elixirTimer.time_left) / elixirTimer.wait_time
	updateElixir(clampf(elixirQuantity+remaining, 0, maxElixir))

func updateElixir(quantity: float):
	elixirBar.value = quantity
	elixirLabel.text = "%d" % quantity

func ConsumeElixir(quantity: float) -> bool:
	if elixirQuantity-quantity < 0:
		return false
	
	elixirQuantity -= quantity
	EventBus.ElixirChanged.emit(elixirQuantity)
	return true

func _on_invoke_ability(ability: Enums.Ability, cost: float):
	if not ConsumeElixir(cost):
		print("Failed to consume ability: %s" % ability)
		return
	print("Ability %s consumed!" % ability)
