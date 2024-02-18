extends PointLight2D

func _ready():
	var flashes = []
	for i in [1, 2, 3, 4, 5]:
		flashes.append("res://scenes/particles/textures/PNG (Transparent)/muzzle_0%s.png"%i)
	texture = load(flashes.pick_random())
	scale = Vector2.ONE * randf_range(0.3, 1.0)
	energy = randf_range(3, 4)
