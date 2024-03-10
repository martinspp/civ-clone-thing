extends Node2D

class_name HexCursor

@onready var sprite: Sprite2D = $Sprite2D
var hex_type: HexType

var _q: int = INF
var _r: int = INF

var q:
	get:
		return _q
	set(val):
		_q = val
		update_pos()
var r:
	get:
		return _r
	set(val):
		_r = val
		update_pos()

func _ready() -> void:
	#(sprite as CanvasItem).z_index = 9999
	pass

func update_pos() -> void:
	position.x = (q * 128)+(r*64)
	position.y = r * 96
	
	
func set_cursor_type(type: String):
	hex_type = load("res://resources/HexTypes/%s.tres" % type)
	if hex_type == null:
		hex_type = load("res://resources/HexTypes/delete.tres")
	sprite.texture = hex_type.cursor_sprite
	
