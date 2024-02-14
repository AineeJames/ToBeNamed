extends Area2D

var velocity: Vector2 = Vector2(0,0)
var speed = 20
var crit

func _ready():
	var timer = Timer.new()
	timer.wait_time = 10
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	queue_free()

func _physics_process(delta):
	global_position += velocity * delta * speed

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		queue_free()
		var damage_amt = randi_range(10, 30)
		body.emit_signal("take_damage", damage_amt, velocity.normalized(), crit)
	else:
		pass
