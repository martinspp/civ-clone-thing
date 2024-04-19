extends Node2D

class_name FowRevealer

@export var fow_range: int

@onready var parent_object: Variant = get_parent()
@onready var revealing_hexes: Array[Hex] = []

static var all_revealed_hexes: Array[Hex] = []

func _ready() -> void:
	pass

func calculate_revealed_hexes() -> void:
	#GameStateService.data_service.
	pass