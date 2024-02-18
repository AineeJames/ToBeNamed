extends Control

var rotation_offset = 0

@onready var ClipBarShader = $ClipBarShader

func set_clip_bar_range(_min_val, max_val):
	ClipBarShader.material.set_shader_parameter("clip_size", max_val)
	
func update_clip_bar_value(value):
	ClipBarShader.material.set_shader_parameter("num_bullets", value)
	
func update_bullets_remaining(value):
	%BulletsCountLabel.text = str(value)
	
func is_reloading(b):
	ClipBarShader.material.set_shader_parameter("is_reloading", b)

func _process(_delta):
	rotation = -rotation_offset
