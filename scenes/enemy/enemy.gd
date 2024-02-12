extends CharacterBody2D

var speed: float = 100.0

var Target: CharacterBody2D
var Health: int = 100

@export var bump_factor: float = 5.0

@onready var HealthBarLabel = $HealthBar/VBoxContainer/Label
@onready var HealthBar = $HealthBar/VBoxContainer/ProgressBar
@onready var Sprite = $Sprite2D

signal take_damage(amount, bump_direction)

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

func _on_take_damage(amount, bump_direction):
	Health -= amount
	HealthBar.value = Health
	velocity = bump_direction
	if Health > 0:
		
		var bump_vector = bump_direction * bump_factor
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(self, "position", position + bump_vector, 0.1).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(Sprite, "modulate", Color.PALE_VIOLET_RED, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(Sprite, "modulate", Color.WHITE, 0.1).set_trans(Tween.TRANS_QUAD)
		
	
	else:
		print("Enemy DIED")
		queue_free()
