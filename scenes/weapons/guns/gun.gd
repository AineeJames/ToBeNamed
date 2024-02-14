extends Node2D

@export var selected_gun: GunResource

@export var movement_influence: float = 0.002
@export var is_ai_gun: bool = false

@onready var GunSprite: Sprite2D = $GunSprite
@onready var Bullet = load("res://scenes/weapons/guns/bullet/bullet.tscn")

var velocity = 0
var prev_position: Vector2

func _ready():
	GunSprite.texture = selected_gun.gun_texture
	GunSprite.scale = selected_gun.gun_texture_scale
	prev_position = global_position

func _physics_process(delta):
	velocity = (global_position - prev_position) / delta
	prev_position = global_position

func _input(event):
	if is_ai_gun:
		return
	
	if not selected_gun.automatic and event.is_action_pressed("fire"):
		fire_bullet()
		
func fire_bullet():
	# Move gun backwards
	var tween = get_tree().create_tween()
	var direction_vector = Vector2(cos(rotation), sin(rotation)).normalized()
	tween.tween_property(self, "position", position + direction_vector * selected_gun.gun_kick, 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", position, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	
	# Add nullet to scene
	var instance = Bullet.instantiate()
	instance.global_position = global_position
	instance.rotation = rotation
	instance.velocity = velocity * movement_influence + Vector2(selected_gun.bullet_speed*cos(rotation + PI), selected_gun.bullet_speed*sin(rotation + PI))
	instance.crit = randi_range(0, 100) < int(selected_gun.crit_chance * 100)
	get_tree().current_scene.add_child(instance)
	if !is_ai_gun and instance.crit:
		GlobalEventBus.player_did_crit.emit()
