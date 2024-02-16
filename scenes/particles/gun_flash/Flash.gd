extends PointLight2D

func _ready():
	scale = Vector2.ONE * randf_range(0.3, 1.0)
	rotation_degrees = randf_range(0, 360)
	energy = randf_range(3, 4)

func _process(delta):
	energy -= 0.01
