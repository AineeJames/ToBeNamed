extends Resource

class_name GunResource

# Info
@export_category("Gun Info")
@export var gun_name: String
@export_multiline var gun_description: String

# Sounds
@export_category("Gun Sounds")
@export var fire_sound: AudioStream
@export var rechamber_sound: AudioStream
@export var rechamber_sound_delay: float = 0
@export var reload_sound: AudioStream

# Stats
@export_category("Gun Stats")
@export var gun_texture: Texture
@export var gun_texture_mirror: bool = false
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
@export var bullet_knockback: float = 0
@export var bullet_amount: int = 1
@export_range(0, 360, 1, "degrees") var bullet_spread = 3

