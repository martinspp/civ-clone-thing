extends Node2D

class_name UnitActionSelectionUI

@export var target_sprite: Sprite2D
@export var line: Line2D

var source_unit: Unit:
	get:
		return source_unit
	set(value):
		source_unit = value
		_source_hex = value.hex

var _source_hex: Hex
var _last_targeted_hex: Hex
var _targeted_hex: Hex:
	get:
		return _targeted_hex
	set(value):
		_last_targeted_hex = _targeted_hex
		_targeted_hex = value
		_needs_rebuild = true

var _final_targeted_hex: Hex

var _hex_path: Array[Hex] = []

var _needs_rebuild: bool = true

func _ready() -> void:
	GameStateService.game_service.selecting_target = true

func _process(delta: float) -> void:
	target_sprite.global_position = get_global_mouse_position()
	if _needs_rebuild:
		_build_path()

func _build_path() -> void:
	_needs_rebuild = false
	if !(_source_hex && _targeted_hex):
		return
	var hex_path := GameStateService.data_service.plot_path(_source_hex, _targeted_hex)
	line.clear_points()
	for hex in hex_path:
		print("%s %s" % [hex.q, hex.r])
		line.add_point(hex.global_position)
	print(line.get_point_count())



func _exit_tree() -> void:
	GameStateService.game_service.selecting_target = false	

func get_target() -> Variant:
	queue_free()
	return _final_targeted_hex