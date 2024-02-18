extends CharacterBody2D

@export var gun_distance_from_player = 35
@export var dash_multiplyer = 3
var angle_of_gun = 0
var player_initial_scale
var player_can_dash = true

@export var GunSprite: Sprite2D

@export var movement_speed: float = 150.0
@export var acceleration: float = 800.0
@export var deceleration: float = 1200.0
@export var max_walk_velocity: float = 200
@export var max_velocity: float = 400
@export var health: int = 100

@export_category("Inventory")
@export var guns: Array[GunResource]
var gun_index = 0
var Gun

@onready var PlayerSprite = $PlayerSprite
@onready var DashTimer = $DashTimer
@onready var PlayerCollision = $CollisionShape2D
@onready var PlayerHealthBar = $PlayerHealthBar
@onready var GunScene = load("res://scenes/weapons/guns/gun.tscn")

var total_damage = 0
var deadzone = 0.1
signal take_damage(amount, bump_direction)

func position_gun():
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
	
func create_gun():
	if Gun:
		Gun.queue_free()
	Gun = GunScene.instantiate()
	Gun.selected_gun = guns[gun_index]
	%SelectedWeaponName.text = "Weapon: " + Gun.selected_gun.gun_name
	add_child(Gun)
	position_gun()

func _input(event):
	if event.is_action_pressed("next_weapon"):
		gun_index = wrap(gun_index + 1, 0, guns.size())
		create_gun()
	if event.is_action_pressed("prev_weapon"):
		gun_index = wrap(gun_index - 1, 0, guns.size())
		create_gun()

func _ready():
	create_gun()
	PlayerHealthBar.max_value = health
	PlayerHealthBar.value = health
	player_initial_scale = PlayerSprite.scale
	GlobalEventBus.updated_dps.connect(update_dps_label)
	GlobalEventBus.updated_killcount.connect(update_killcount_label)
	GlobalEventBus.updated_critcount.connect(update_critcount_label)
	GlobalEventBus.did_damage.connect(update_damage_label)
	GlobalEventBus.enemy_killed.connect(update_enemies_label)
	GlobalEventBus.enemy_spawned.connect(update_enemies_label)
	take_damage.connect(took_damage)

func _physics_process(delta):
	update_fps_label()
	# Get the input direction and handle the movement/acceleration/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		PlayerSprite.flip_h = direction == 1
		velocity.x = move_toward(velocity.x, direction * max_walk_velocity, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

	var ydirection = Input.get_axis("move_up", "move_down")
	if ydirection:
		velocity.y = move_toward(velocity.y, ydirection * max_walk_velocity, acceleration * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, deceleration * delta)
		
	if Input.is_action_just_pressed("dash") and player_can_dash:
		player_can_dash = false
		PlayerCollision.disabled = true
		
		var new_velocity = (velocity * dash_multiplyer).clamp(-Vector2(max_velocity, max_velocity), Vector2(max_velocity, max_velocity))
		var new_scale = (PlayerSprite.scale - (abs(new_velocity) / (max_velocity * 1.2) * PlayerSprite.scale)).clamp(Vector2.ZERO, Vector2.ONE)
		new_scale = Vector2(new_scale.y, new_scale.x)
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(self, "velocity", new_velocity, 0.1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(PlayerSprite, "scale", new_scale, 0.25).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(PlayerSprite, "modulate", Color(0, 0, 0, 0.2), 0.25).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.tween_property(PlayerSprite, "scale", player_initial_scale, 0.20).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		tween.parallel().tween_property(PlayerSprite, "modulate", Color.WHITE, 0.20).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.tween_callback(func(): PlayerCollision.disabled = false)
		
		DashTimer.start()

	move_and_slide()

	position_gun()

func took_damage(amount, bump_vector):
	print("took ", amount , "damage")
	health -= amount
	PlayerHealthBar.value = health
	if health < 0:
		print("Deaded :(")

func update_dps_label(dps):
	%DPSLabel.text = "DPS: " + str(dps)
	
func update_critcount_label(critcount):
	%CritLabel.text = "Crits: " + str(critcount)
	
func update_killcount_label(killcount):
	%KillLabel.text = "Kills: " + str(killcount)
	
func update_damage_label(damage):
	total_damage += damage
	%TotalDamageLabel.text = "Total Damage: " + str(total_damage)

func update_enemies_label(spawn_time):
	%EnemiesAliveLabel.text = "Enemies Alive: " + str(GlobalEventBus.enemies_alive)
	%EnemiesSpawnTimeLabel.text = "Spawn Time: " + str(GlobalEventBus.enemy_spawn_time)
	
func update_fps_label():
	%FPSLabel.text = "FPS: " + str(Engine.get_frames_per_second())
	
func _on_dash_timer_timeout():
	player_can_dash = true
