@tool
extends Control

class_name UIBase

@export var assume_theme: Theme:
	set(new_theme):
		assume_theme = new_theme
		theme = new_theme

const MOBILE = preload("uid://ddtv8ntjqwl0a")
const WEB = preload("uid://dpdjhl4yqpu08")
const DESKTOP = preload("uid://bfmc47373h4sf")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		self.theme = assume_theme
		return
	
	self.theme = MOBILE
	
	if ProjectFeatures.IsMacos or ProjectFeatures.IsWindows or ProjectFeatures.IsLinux:
		self.theme = DESKTOP
	elif ProjectFeatures.IsWeb:
		self.theme = WEB
		
	print("Theme is: ", self.theme)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		self.theme = assume_theme
		return
