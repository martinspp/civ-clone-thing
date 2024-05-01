extends Resource

class_name UnitType

@export var unit_name: String
@export var health: float
@export var speed: int
@export var sprite: CompressedTexture2D
@export var actions: Array[String]
@export var attack_damage: float
## Used strictly for actions
@export var action_points: int
## Used strictily for movement
@export var movement_points: int
@export var fow_range: int

func _init() -> void:
	pass