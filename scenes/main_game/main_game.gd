extends Node2D

@onready var player = $Player
var enemy_scene = load("res://scenes/enemy/enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn_enemy():
	print("Spawning enemy")
	var spawn_position = pick_spawn_location()
	var enemy = enemy_scene.instantiate()
	enemy.position = spawn_position
	add_child(enemy)
	#enemy.move_towards_player(player.position) # You'll implement this in your enemy script


func pick_spawn_location() -> Vector2:
	# This is a simple example. You might want to customize it.
	# For 2D, picks a random position off-screen, but you could use player's view for 3D.
	var viewport_rect = get_viewport_rect()
	var player_pos = player.global_position
	var spawn_margin = 100 # Pixels outside the viewport to spawn the enemy
	var spawn_position = Vector2()

	# Pick a side to spawn from (top, bottom, left, right)
	var side = randi() % 4
	match side:
		0: # Top
			spawn_position.x = randi_range(viewport_rect.position.x, viewport_rect.end.x)
			spawn_position.y = player_pos.y - viewport_rect.size.y / 2 - spawn_margin
		1: # Bottom
			spawn_position.x = randi_range(viewport_rect.position.x, viewport_rect.end.x)
			spawn_position.y = player_pos.y + viewport_rect.size.y / 2 + spawn_margin
		2: # Left
			spawn_position.x = player_pos.x - viewport_rect.size.x / 2 - spawn_margin
			spawn_position.y = randi_range(viewport_rect.position.y, viewport_rect.end.y)
		3: # Right
			spawn_position.x = player_pos.x + viewport_rect.size.x / 2 + spawn_margin
			spawn_position.y = randi_range(viewport_rect.position.y, viewport_rect.end.y)

	return spawn_position


func _on_enemy_timer_timeout():
	spawn_enemy()
