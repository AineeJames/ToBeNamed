extends Node2D

var Bullet = load("res://scenes/guns/bullet.tscn")

@export var gun_kick: float = 10.0
@export var movement_influence: float = 0.002
@export var projectile_speed: float = 20
@export var crit_percentage: int = 50
@export var is_ai_gun: bool = false

var velocity = 0
var prev_position: Vector2

func _ready():
	prev_position = global_position

func _physics_process(delta):
	velocity = (global_position- prev_position) / delta
	prev_position = global_position

func fire_bullet():
	# Move gun backwards
	var tween = get_tree().create_tween()
	var direction_vector = Vector2(cos(rotation), sin(rotation)).normalized()
	tween.tween_property(self, "position", position + direction_vector * gun_kick, 0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", position, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	
	# Add nullet to scene
	var instance = Bullet.instantiate()
	instance.global_position = global_position
	instance.rotation = rotation
	instance.velocity = velocity * movement_influence + Vector2(projectile_speed*cos(rotation + PI), projectile_speed*sin(rotation + PI))
	instance.crit = randi_range(0, 100) < crit_percentage
	get_tree().current_scene.add_child(instance)
	
func _input(event):
	if is_ai_gun:
		return
		
	if event.is_action_pressed("fire"):
		fire_bullet()
