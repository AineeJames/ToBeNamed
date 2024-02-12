extends Node2D

var Bullet = load("res://scenes/guns/bullet.tscn")

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("fire"):
			var instance = Bullet.instantiate()
			instance.global_position = global_position
			instance.rotation = rotation
			
			instance.velocity = Vector2(10*cos(rotation + PI), 10*sin(rotation + PI))
			get_tree().current_scene.add_child(instance)
