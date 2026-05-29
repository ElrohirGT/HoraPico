extends NinePatchRect

class_name PlayerPointerButton

@export var cost: float
@export var actionTexture: Texture2D
@export var selected: bool
@export var ability: Enums.Ability

@export var availableBackground: Texture2D
@export var unavailableBackground: Texture2D
@export var selectedBackground: Texture2D

@onready var costLabel: Label = $HBoxContainer/Cost
@onready var mainTexture: TextureRect = $MainTexture

func _ready() -> void:
	mainTexture.texture = actionTexture
	costLabel.text = "%.0f" % cost
	texture = unavailableBackground

func _process(delta: float) -> void:
	var canBuy = HUD.elixirQuantity > cost
	if selected && canBuy:
		texture = selectedBackground
	elif !canBuy:
		texture = unavailableBackground
	else:
		texture = availableBackground
