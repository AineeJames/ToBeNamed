extends Area2D

var velocity: Vector2 = Vector2(0,0)
var speed = 20

func _ready():
	# Create a new Timer node.
	var timer = Timer.new()
	# Set the timer to trigger once after 20 seconds.
	timer.wait_time = 10
	timer.one_shot = true
	# Add the timer as a child of the current node.
	add_child(timer)
	# Connect the timer's "timeout" signal to a custom function.
	timer.connect("timeout", _on_timer_timeout)
	# Start the timer.
	timer.start()

func _on_timer_timeout():
	# Function to be called when the timer reaches 0.
	# This will delete the current node.
	queue_free()

func _physics_process(delta):
	global_position += velocity * delta * speed

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		queue_free()
		var damage_amt = randi_range(10, 30)
		body.emit_signal("take_damage", damage_amt, velocity.normalized())
	else:
		pass
