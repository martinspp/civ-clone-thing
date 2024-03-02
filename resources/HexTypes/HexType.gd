extends Resource

class_name HexType

@export var sprite: CompressedTexture2D
@export var data_name: String

func _init() -> void:
	sprite = load("res://sprites/tileGrass.png")
	data_name = "grass"
