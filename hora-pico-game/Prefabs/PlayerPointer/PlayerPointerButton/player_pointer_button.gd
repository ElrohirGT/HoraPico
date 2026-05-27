extends NinePatchRect

@export var cost: float
@export var actionTexture: Texture2D

@export var availableBackground: Texture2D
@export var unavailableBackground: Texture2D

@onready var costLabel: Label = $HBoxContainer/Cost
@onready var mainTexture: TextureRect = $MainTexture

func _ready() -> void:
	mainTexture.texture = actionTexture
	costLabel.text = "%.0f" % cost
	texture = unavailableBackground

func _process(delta: float) -> void:
	if HUD.elixirQuantity < cost:
		texture = unavailableBackground
	else:
		texture = availableBackground
