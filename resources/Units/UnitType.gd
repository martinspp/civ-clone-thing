extends Resource

class_name UnitType

@export var unit_name: String
@export var health: float
@export var speed: float
@export var sprite: CompressedTexture2D
@export var actions: Array[String]
@export var attack_damage: float
@export var action_points: int

func _init() -> void:
	pass