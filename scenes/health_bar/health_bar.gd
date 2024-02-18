extends Node2D

@export var health_bar_visibility_time: float = 2.0
@export var health_bar_fade_time: float = 1.0

@onready var VisibilityTimer = $VisibilityTimer
@onready var Info = $HBoxContainer
@onready var HealthBar = $HBoxContainer/VBoxContainer/CenterContainer/ProgressBar
@onready var NameLabel = $HBoxContainer/VBoxContainer/Label
@onready var Percent = $HBoxContainer/PercentLabel

func _physics_process(_delta):
	if VisibilityTimer.time_left < health_bar_fade_time:
		modulate.a = VisibilityTimer.time_left / health_bar_fade_time
	else:
		modulate.a = 1.0

func _on_visibility_timer_timeout():
	visible = false

func _on_progress_bar_value_changed(value):
	Percent.text = "%.01f%%" % (value / HealthBar.max_value * 100)
	if value < HealthBar.max_value:
		visible = true
		VisibilityTimer.start(health_bar_visibility_time)
	
func set_max_health(value):
	HealthBar.max_value = value
	
func set_health(value):
	HealthBar.value = value
	
func set_label(msg):
	NameLabel.text = msg
	
