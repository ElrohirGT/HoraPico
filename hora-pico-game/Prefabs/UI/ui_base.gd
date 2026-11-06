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

@onready var fail_timer: Timer = $TrafficBackground/FailTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.ComboFail.connect(_on_fail_combo)
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

func _on_fail_combo(is_failed: bool) -> void:
	if is_failed:
		fail_timer.start()

func _on_fail_timer_timeout() -> void:
	print("HJASUHNjsuia")
	EventBus.ComboFail.emit(false)
