extends Node2D

var Bullet = load("res://scenes/guns/bullet.tscn")

@export var gun_kick: float = 10.0

func _input(event):
	if event.is_action_pressed("fire"):
		
		# Move gun backwards
		var tween = get_tree().create_tween()
		var direction_vector = Vector2(cos(rotation), sin(rotation)).normalized()
		tween.tween_property(self, "position", position + direction_vector * gun_kick, 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position", position, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		
		# Add nullet to scene
		var instance = Bullet.instantiate()
		instance.global_position = global_position
		instance.rotation = rotation
		instance.velocity = Vector2(10*cos(rotation + PI), 10*sin(rotation + PI))
		get_tree().current_scene.add_child(instance)
