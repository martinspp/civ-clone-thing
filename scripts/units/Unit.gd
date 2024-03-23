extends Node2D
class_name Unit

# should only be set once when Unit.gd is initialized
var unit_data: UnitType:
	get:
		return unit_data
	set(value):
		sprite_2d.texture = value.sprite
		unit_data = value.new()


@export var sprite_2d: Sprite2D

var player: Player
var hex: Hex

func _ready() -> void:
	pass



func serialize() -> Dictionary:
	var dict = {}
	dict["unit_type"] = unit_data.unit_name
	dict["health"] = unit_data.health
	dict["speed"] = unit_data.speed
	dict["owner_id"] = player.id
	return dict

func deserialize(data: Dictionary) -> void:
	unit_data = ResourceRegistry.get_unit_type_by_name(data["unit_type"]).new()
	player = GameStateService.data_service.get_player_by_id(data["onwer_id"])