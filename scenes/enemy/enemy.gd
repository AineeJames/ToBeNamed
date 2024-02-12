extends CharacterBody2D

var speed: float = 100.0

var Target: CharacterBody2D
var Health: int = 100

@onready var HealthBarLabel = $HealthBar/VBoxContainer/Label
@onready var HealthBar = $HealthBar/VBoxContainer/ProgressBar

signal take_damage(amount)

func _ready():
	HealthBarLabel.text = "Enemy"
	HealthBar.max_value = Health
	HealthBar.value = Health

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
	#rotation = direction_to_center.angle()	

func _on_take_damage(amount):
	Health -= amount
	HealthBar.value = Health
	if Health < 0:
		print("Enemy DIED")
		queue_free()
