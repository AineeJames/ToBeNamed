extends Node2D

@export var health_bar_visibility_time: float = 2.0
@export var health_bar_fade_time: float = 1.0

@onready var VisibilityTimer = $VisibilityTimer
@onready var Info = $VBoxContainer
@onready var HealthBar = $VBoxContainer/ProgressBar

func _physics_process(delta):
	if VisibilityTimer.time_left < health_bar_fade_time:
		modulate.a = VisibilityTimer.time_left / health_bar_fade_time
	else:
		modulate.a = 1.0

func _on_visibility_timer_timeout():
	visible = false

func _on_progress_bar_value_changed(value):
	if value < HealthBar.max_value:
		visible = true
		VisibilityTimer.start(health_bar_visibility_time)
	
