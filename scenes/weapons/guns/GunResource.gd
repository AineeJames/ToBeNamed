extends Resource

class_name GunResource

# Stats
@export var fire_rate: int = 5
@export var clip_size: int = 8
@export var bullet_speed: int = 20
@export var reload_time: float = 2
@export var crit_chance: float = 0.1
@export var gun_kick: float = 10.0
@export var automatic: bool = false

# Gun
@export var gun_texture: Texture
@export var gun_texture_scale: Vector2 = Vector2(1, 1)

# Bullet
@export var bullet_texture: Texture
