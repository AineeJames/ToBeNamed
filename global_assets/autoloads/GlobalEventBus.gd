extends Node

signal did_damage(amount)
signal player_did_crit()
signal enemy_killed()
signal enemy_spawned()

signal updated_dps(dps)
signal updated_killcount(killcount)
signal updated_critcount(critcount)

var damage_done: int
var kill_count: int
var player_crit_count: int
var seconds_since_start: int
var timer: Timer
const dps_rolling_window_len_seconds = 5
const dps_calc_delay = 0.25
var DpsCalcTimer: Timer
var damage_per_second: int = 0
var enemies_alive: int = 0

var DamageValues: PackedInt32Array
var Timestamps: PackedInt32Array

# Called when the node enters the scene tree for the first time.
func _ready():
	did_damage.connect(_on_did_damage)
	enemy_killed.connect(_on_enemy_killed)
	player_did_crit.connect(_on_player_did_crit)
	enemy_spawned.connect(_on_enemy_spawned)
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
	var current_time = int(Time.get_ticks_msec() / 1000.0) # Current time in seconds
	
	# Remove events no longer in the DPS window
	while Timestamps.size() > 0 and current_time - Timestamps[0] > dps_rolling_window_len_seconds:
		Timestamps.remove_at(0) # Remove the oldest timestamp
		DamageValues.remove_at(0) # Remove the corresponding damage value

	# Sum up the damage of the remaining events
	var damage_sum = 0
	for damage in DamageValues:
		damage_sum += damage

	# Calculate DPS
	var damage_per_second = damage_sum / float(dps_rolling_window_len_seconds) if Timestamps.size() > 0 else 0.0
	updated_dps.emit(damage_per_second)

func _on_game_timer_timeout():
	seconds_since_start += 1

func _on_player_did_crit():
	player_crit_count += 1
	updated_critcount.emit(player_crit_count)

func _on_did_damage(amount):
	damage_done += amount
	var current_time = Time.get_ticks_msec() / 1000.0
	DamageValues.append(amount)
	Timestamps.append(current_time)

func _on_enemy_killed():
	kill_count += 1
	updated_killcount.emit(kill_count)
	enemies_alive -= 1

func _on_enemy_spawned():
	enemies_alive += 1
