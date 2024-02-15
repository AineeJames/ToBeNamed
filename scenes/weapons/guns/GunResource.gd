extends Resource

class_name GunResource

# Stats
@export_category("Gun Stats")
@export var gun_texture: Texture
@export var gun_texture_scale: Vector2 = Vector2(1, 1)

@export var automatic: bool = false
@export var fire_rate: int = 5

@export var clip_size: int = 8
@export var reload_time: float = 2

@export var crit_chance: float = 0.1
@export var gun_kick: float = 10.0

# Bullet
@export_category("Bullet Stats")
@export var bullet_texture: Texture
@export var bullet_speed: int = 20
@export var bullet_damage: float = 15.0
@export_range(0, 360, 1, "degrees") var bullet_spread = 3

