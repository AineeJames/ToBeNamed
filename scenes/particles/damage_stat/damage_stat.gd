extends Node2D

@onready var Particle = $DamgeParticle
@onready var DamageLabel = $SubViewport/DamageLabel

@export var crit_color: Color = Color.ORANGE
@export var noncrit_color: Color = Color.RED

func emit_damage(val, crit):
	if crit:
		DamageLabel.add_theme_color_override("font_color", crit_color)
	else:
		DamageLabel.add_theme_color_override("font_color", noncrit_color)
	DamageLabel.text = "-%.01f" % val
	Particle.emitting = true
	
