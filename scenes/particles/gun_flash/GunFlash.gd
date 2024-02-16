extends Node2D

var smoke_done = false
var fire_done = false

@onready var Fire = $FireParticles
@onready var Smoke = $SmokeParticles
@onready var Flash = $Flash

func emit_flash():
	Smoke.emitting = true
	Fire.emitting = true

func set_flash_angle(angle):
	Smoke.direction = Vector2(1*cos(angle + PI), 1*sin(angle + PI))
	Fire.direction = Vector2(1*cos(angle + PI), 1*sin(angle + PI))

func _process(delta):
	if smoke_done and fire_done:
		queue_free()

func _on_smoke_particles_finished():
	smoke_done = true

func _on_fire_particles_finished():
	fire_done = true

func _on_gun_flash_timer_timeout():
	Flash.queue_free()
