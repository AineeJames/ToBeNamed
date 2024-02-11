extends CharacterBody2D

var speed: float = 100.0

var Target: CharacterBody2D
var Health: int = 100
func add_target(target):
	Target = target

func _physics_process(delta):
	var direction_to_center = (Target.global_position - global_position).normalized()
	var move_vector = direction_to_center * speed * delta
	# If the character is a KinematicBody2D, use move_and_slide() or move_and_collide()
	# If it's another type of Node2D, you might directly adjust the position
	position += move_vector

	# Optional: Adjust the character's rotation to face the direction of movement
	# Comment out the next line if you don't want the character to rotate
	rotation = direction_to_center.angle()	

func TakeDamage(damage):
	Health -= damage
	if Health < 0:
		queue_free()
