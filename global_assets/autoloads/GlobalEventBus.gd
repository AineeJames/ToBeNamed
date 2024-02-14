extends Node

signal did_damage(amount)
signal player_did_crit()
signal enemy_killed()

var damage_done: int
var kill_count: int
var player_crit_count: int
var GameTimer: Timer
var seconds_since_start: int
var timer: Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	did_damage.connect(_on_did_damage)
	enemy_killed.connect(_on_enemy_killed)
	player_did_crit.connect(_on_player_did_crit)
	timer = Timer.new()
	timer.autostart
	timer.timeout.connect(_on_game_timer_timeout)
	damage_done = 0
	kill_count = 0
	player_crit_count = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_game_timer_timeout():
	seconds_since_start += 1
	timer.call_deferred("queue_free")
	timer = timer.new()
	timer.timeout.connect(_on_game_timer_timeout)

func _on_player_did_crit():
	player_crit_count += 1

func _on_did_damage(amount):
	damage_done += amount

func _on_enemy_killed():
	kill_count += 1
