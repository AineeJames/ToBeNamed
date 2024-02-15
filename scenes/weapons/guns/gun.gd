extends Node2D

@export var selected_gun: GunResource

@export var movement_influence: float = 0.002
@export var is_ai_gun: bool = false

@onready var GunSprite: Sprite2D = $GunSprite
@onready var ReloadTimer: Timer = $ReloadTimer
@onready var ReloadingBar = $Control/CenterContainer/ReloadingProgressBar
@onready var ClipBar = $Control/CenterContainer/ClipBar
@onready var BulletCounter = $Control/BulletsCountLabel
@onready var FireRateTimer = $FireRateTimer
@onready var Bullet = load("res://scenes/weapons/guns/bullet/bullet.tscn")

var velocity = 0
var prev_position: Vector2
var bullets_remaining: int
var can_shoot = true
var fire_held = false

func _ready():
	GunSprite.texture = selected_gun.gun_texture
	GunSprite.scale = selected_gun.gun_texture_scale
	bullets_remaining = selected_gun.clip_size
	prev_position = global_position
	ReloadingBar.min_value = 0
	ReloadingBar.max_value = selected_gun.reload_time
	ClipBar.max_value = selected_gun.clip_size
	ClipBar.min_value = 0

func _physics_process(delta):
	velocity = (global_position - prev_position) / delta
	prev_position = global_position
	ReloadingBar.value = ReloadTimer.time_left
	ClipBar.value = bullets_remaining
	BulletCounter.text = str(bullets_remaining)
	if fire_held and can_shoot and bullets_remaining > 0:
		if selected_gun.automatic:
			can_shoot = false
			fire_bullet()
			FireRateTimer.start(1. / selected_gun.fire_rate)

func _input(event):
	if is_ai_gun:
		return
		
	if event.is_action_pressed("fire"):
		fire_held = true
	if event.is_action_released("fire"):
		fire_held = false
		
	if bullets_remaining > 0 and event.is_action_pressed("reload"):
		ReloadingBar.visible = true
		ClipBar.visible = false
		bullets_remaining = 0
		ReloadTimer.start(selected_gun.reload_time)
	
	if not selected_gun.automatic and event.is_action_pressed("fire") and bullets_remaining > 0 and can_shoot:
		fire_bullet()
		
		
func _on_reload_timer_timeout():
	bullets_remaining = selected_gun.clip_size
	ReloadingBar.visible = false
	ClipBar.visible = true

func _on_fire_rate_timer_timeout():
	can_shoot = true

func fire_bullet():
	
	# Move gun backwards
	var tween = get_tree().create_tween()
	var direction_vector = Vector2(cos(rotation), sin(rotation)).normalized()
	tween.tween_property(self, "position", position + direction_vector * selected_gun.gun_kick, 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", position, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	
	# Add nullet to scene
	var instance = Bullet.instantiate()
	instance.global_position = global_position
	instance.rotation = rotation + deg_to_rad(randf_range(-selected_gun.bullet_spread, selected_gun.bullet_spread))
	instance.velocity = velocity * movement_influence + Vector2(selected_gun.bullet_speed*cos(instance.rotation + PI), selected_gun.bullet_speed*sin(instance.rotation + PI))
	instance.crit = randi_range(0, 100) < int(selected_gun.crit_chance * 100)
	instance.damage = selected_gun.bullet_damage
	instance.bullet_speed = selected_gun.bullet_speed
	get_tree().current_scene.add_child(instance)
	if !is_ai_gun and instance.crit:
		GlobalEventBus.player_did_crit.emit()
	
	bullets_remaining -= 1
	if bullets_remaining == 0:
		ReloadingBar.visible = true
		ClipBar.visible = false
		ReloadTimer.start(selected_gun.reload_time)

