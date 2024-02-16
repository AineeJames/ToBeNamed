extends Control

var rotation_offset = 0

func show_reloading():
	%ReloadingProgressBar.visible = true
	%ClipBar.visible = false
	
func show_clip():
	%ReloadingProgressBar.visible = false
	%ClipBar.visible = true

func set_reloading_bar_range(min, max):
	%ReloadingProgressBar.min_value = min
	%ReloadingProgressBar.max_value = max
	
func set_clip_bar_range(min, max):
	%ClipBar.min_value = min
	%ClipBar.max_value = max

func update_reloading_bar_value(value):
	%ReloadingProgressBar.value = value
	
func update_clip_bar_value(value):
	%ClipBar.value = value
	
func update_bullets_remaining(value):
	%BulletsCountLabel.text = str(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	offset_rotation()
	pass
	
func offset_rotation():
	rotation = -rotation_offset
