extends CharacterBody2D

@export var speed: float = 100.0
@export var max_speed: Vector2 = Vector2(100,100)
var Target: CharacterBody2D
var Health: int = 100
var dying = false

@export var bump_factor: float = 5.0

@onready var Sprite = $Sprite2D
@onready var CollisionShape = $CollisionShape2D
@onready var HealthBar = $HealthBar
@onready var NavAgent = $NavigationAgent2D
var movement_delta: float
var BloodParticles = load("res://scenes/particles/blood/blood_particles.tscn")
var DamageStat = load("res://scenes/particles/damage_stat/damage_stat.tscn")

signal take_damage(amount, bump_direction)

const monsterNames = [
	"Sharon",
	"Daniel",
	"Darnell",
	"Ronnie",
	"Bob"
]

const monsterDescriptors = [
	"Big",
	"Angry",
	"Slow",
	"Crazy"
]

func _ready():
	var enemy_name = monsterNames[randi() % monsterNames.size()]
	var desc = monsterDescriptors[randi() % monsterDescriptors.size()]
	HealthBar.set_label("%s %s" % [desc, enemy_name])
	HealthBar.set_max_health(Health)
	HealthBar.set_health(Health)
	NavAgent.velocity_computed.connect(Callable(_on_velocity_computed))

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	global_position = global_position.move_toward(global_position + safe_velocity, movement_delta)

func add_target(target):
	Target = target
	NavAgent.target_position = Target.global_position

func _physics_process(delta):
	NavAgent.target_position = Target.global_position
	#var target_pos = NavAgent.get_next_path_position()
	#var direction_to_center = (target_pos - global_position).normalized()
	#var move_vector = direction_to_center * speed * delta
	
	# If the character is a KinematicBody2D, use move_and_slide() or move_and_collide()
	# If it's another type of Node2D, you might directly adjust the position
	#if not dying:
	#	move_and_collide(move_vector)
		# TODO: need the guys to not get stuck on each other

	# Optional: Adjust the character's rotation to face the direction of movementas
	# Comment out the next line if you don't want the character to rotate
	# rotation = direction_to_center.angle()		
	if !NavAgent.is_navigation_finished():
		movement_delta = speed * delta
		
		var current_agent_position = global_position
		var next_path_position = NavAgent.get_next_path_position()
		#velocity = (next_path_position - current_agent_position).normalized() * movement_delta
		var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_delta
		if NavAgent.avoidance_enabled:
			NavAgent.set_velocity(new_velocity)
		else:
			_on_velocity_computed(new_velocity)
		if not dying:
			move_and_slide()

func _on_take_damage(amount, bump_direction):
	
	var damagestat_instance = DamageStat.instantiate()
	damagestat_instance.global_position = global_position
	get_tree().current_scene.add_child(damagestat_instance)
	damagestat_instance.emit_damage(amount)
	
	Health -= amount
	HealthBar.set_health(Health)
	
	var blood_instance = BloodParticles.instantiate()
	blood_instance.global_position = global_position
	blood_instance.emitting = true
	blood_instance.direction = bump_direction
	get_tree().current_scene.add_child(blood_instance)
	
	var bump_vector = bump_direction * bump_factor
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "position", position + bump_vector, 0.1).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(Sprite, "modulate", Color.PALE_VIOLET_RED, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(Sprite, "modulate", Color.WHITE, 0.1).set_trans(Tween.TRANS_QUAD)
	
	if Health <= 0:
		call_deferred("disable_collision")
		dying = true
		HealthBar.visible = false
		tween = get_tree().create_tween()
		tween.parallel().tween_property(Sprite, "modulate", Color.TRANSPARENT, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_callback(queue_free)

func disable_collision():
	#did this deferred because 
	CollisionShape.disabled = true
