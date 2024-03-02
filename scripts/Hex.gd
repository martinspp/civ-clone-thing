extends Node2D

class_name Hex

@onready var sprite: Sprite2D = $Sprite2D
var hex_type: HexType

static var world: World

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
	pass

func delete() -> void:
	queue_free()

func update_pos() -> void:
	position.x = (q * 128)+(r*64)
	position.y = r * 96
	
func set_hex_type(type: String):
	hex_type = load("res://resources/HexTypes/%s.tres" % type)
	sprite.texture = hex_type.sprite

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed == true:
			world.hex_clicked(self)
