extends CharacterBody2D

@export var movement_speed: float = 150.0
@export var acceleration: float = 800.0
@export var deceleration: float = 1200.0
@export var max_velocity: float = 200.0

func _physics_process(delta):
	# Get the input direction and handle the movement/acceleration/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_velocity, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

	var ydirection = Input.get_axis("move_up", "move_down")
	if ydirection:
		velocity.y = move_toward(velocity.y, ydirection * max_velocity, acceleration * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, deceleration * delta)    

	move_and_slide()
