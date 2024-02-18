extends Node2D

@onready var Gun = $Gun
@onready var Attack_Area = $Attack_Radius
@export var gun_distance_from_minion = 35
@export var minion_disabled: bool = false

# Called when the node enters the scene tree for the first time.
var have_target: bool = false
func _ready():
	set_gun_target_position(global_position + Vector2(-1,0))

func set_gun_target_position(pos: Vector2):
	var angle_of_gun = (pos - global_position).angle()

	Gun.global_position = global_position + Vector2(cos(angle_of_gun), sin(angle_of_gun)) * gun_distance_from_minion
	Gun.look_at(global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var potential_targets = Attack_Area.get_overlapping_bodies()
	var closest_enemy = null
	var closest_distance = INF # Use infinity as the initial comparison value

	for target in potential_targets:
		if target.is_in_group("enemy"): # Assuming 'enemy' is the group name for enemy objects
			var distance = position.distance_to(target.position) # Calculate distance to the target
			
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = target

	if closest_enemy:
		set_gun_target_position(closest_enemy.global_position)
		have_target = true
	else:
		have_target = false


func _on_attack_timer_timeout():
	if not minion_disabled and have_target:
		Gun.fire_bullet()
