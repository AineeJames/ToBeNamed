extends Node

signal did_damage(amount)
signal player_did_crit()
signal enemy_killed()

var damage_done: int
var kill_count: int
var player_crit_count: int
var seconds_since_start: int
var timer: Timer
const dps_rolling_window_len_seconds = 5
const dps_calc_delay = 0.25
var DpsCalcTimer: Timer
var damage_per_second: int = 0


class DamageEvent:
	var damage: int
	var timestamp_sec: int

var DamageQueue: Array[DamageEvent]

# Called when the node enters the scene tree for the first time.
func _ready():
	did_damage.connect(_on_did_damage)
	enemy_killed.connect(_on_enemy_killed)
	player_did_crit.connect(_on_player_did_crit)
	timer = Timer.new()
	timer.autostart = true
	timer.timeout.connect(_on_game_timer_timeout)
	add_child(timer)
	
	DpsCalcTimer = Timer.new()
	DpsCalcTimer.autostart = true
	DpsCalcTimer.wait_time = 0.25
	DpsCalcTimer.timeout.connect(calc_dps)
	add_child(DpsCalcTimer)
	
	damage_done = 0
	kill_count = 0
	player_crit_count = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func calc_dps():
	# remove events no longer in window
	var current_time = Time.get_ticks_msec() / 1000.0
	while DamageQueue.size() > 0 and current_time - DamageQueue[0].timestamp_sec > dps_rolling_window_len_seconds:
		DamageQueue.pop_front()
		
	var damage_sum = 0
	for damage_event in DamageQueue:
		damage_sum += damage_event.damage
	damage_per_second = damage_sum / dps_rolling_window_len_seconds

func _on_game_timer_timeout():
	seconds_since_start += 1

func _on_player_did_crit():
	player_crit_count += 1

func _on_did_damage(amount):
	damage_done += amount
	var current_time = Time.get_ticks_msec() / 1000.0
	var event = DamageEvent.new()
	event.damage = amount
	event.timestamp_sec = current_time
	DamageQueue.append(event)
	

func _on_enemy_killed():
	kill_count += 1
