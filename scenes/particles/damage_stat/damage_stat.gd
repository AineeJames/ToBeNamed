extends Node2D

@onready var Particle = $DamgeParticle
@onready var DamageLabel = $SubViewport/DamageLabel

func emit_damage(val):
	DamageLabel.text = "-%.01f" % val
	Particle.emitting = true
	
