extends CharacterBody2D

@export var gun_distance_from_player = 35
var angle_of_gun = 0

@export var GunSprite: Sprite2D

@export var movement_speed: float = 150.0
@export var acceleration: float = 800.0
@export var deceleration: float = 1200.0
@export var max_velocity: float = 200.0

@onready var Gun = $PlayerGun

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
		
	if Input.is_action_just_pressed("dash"):
		velocity.x = move_toward(velocity.x, velocity.x * 5, acceleration * delta * 25)
		velocity.y = move_toward(velocity.y, velocity.y * 5, acceleration * delta * 25)

	move_and_slide()
	
	var deadzone = 0.1
	if Input.get_connected_joypads().size() > 0:
		var x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
		var y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
		if abs(x) > deadzone || abs(y) > deadzone:
			angle_of_gun = Vector2(x, y).angle()
	else:
		var mouse_pos = get_global_mouse_position()
		angle_of_gun = (mouse_pos - global_position).angle()

	Gun.global_position = global_position + Vector2(cos(angle_of_gun), sin(angle_of_gun)) * gun_distance_from_player
	Gun.look_at(global_position)
