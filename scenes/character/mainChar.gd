extends CharacterBody2D


var gun_distance_from_player = 50

@export var GunSprite: Sprite2D
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
	
	var mouse_pos = get_global_mouse_position()
	var angle_to_mouse = (mouse_pos - global_position).angle()
	#angle_to_mouse = PI
	
	GunSprite.global_position = global_position + Vector2(cos(angle_to_mouse), sin(angle_to_mouse)) * gun_distance_from_player
	GunSprite.look_at(global_position)
