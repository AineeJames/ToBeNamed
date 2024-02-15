extends Resource

class_name EnemyResource

@export var Health: int = 100
@export var MoveSpeed: int = 100
@export var MaxMoveSpeed: int = 100
@export var AttackCooldown: int = 1
@export var EnemySprite: Texture
@export var AttackSound: AudioStream
@export var AttackRadius: int = 100
@export var AttackPower: int = 10
# TODO: How can we define collision shapes per enemy?
