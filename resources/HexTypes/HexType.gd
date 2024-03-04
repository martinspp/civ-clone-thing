extends Resource

class_name HexType

@export var world_sprite: CompressedTexture2D
@export var cursor_sprite: CompressedTexture2D
@export var data_name: String

func _init() -> void:
	world_sprite = load("res://sprites/hex/tileGrass.png")
	cursor_sprite = load("res://sprites/hex/tileGrass_tile.png")
	data_name = "grass"
