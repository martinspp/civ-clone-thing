extends Node2D

class_name HexCursor

@onready var sprite: Sprite2D = $Sprite2D
@onready var line: Line2D = $Line2D
#var hex_type: HexType

static var cursor_settings := {
	"hex":{
		"transform": Transform2D(0.0, Vector2(1.969,1.969), 0, Vector2(0,23.027)),
		"color": Color.WHITE},
	"object":{
		"transform" :Transform2D(0.0, Vector2.ONE, 0, Vector2(1.215,1.215)),
		"color": Color(1,1,1,0.5)},
	"action":{
		"transform": Transform2D(0.0, Vector2(1.969,1.969), 0, Vector2(0,23.027)),
		"color": Color.WHITE},
	"test":{
		"transform": Transform2D(0.0, Vector2(1.969,1.969), 0, Vector2(0,23.027)),
		"color": Color.WHITE}
}

var q : int = int(INF) :
	get:
		return q
	set(val):
		q = val
		update_pos()
var r :int = int(INF):
	get:
		return r
	set(val):
		r = val
		update_pos()

func _ready() -> void:
	(self as CanvasItem).z_index = 1

func update_pos() -> void:
	if q == null || r == null:
		return
	position.x = (q * 128)+(r*64)
	position.y = r * 96
	
	
func set_cursor_type(type: String, subtype: String) -> void:
	sprite.transform = cursor_settings[type]["transform"]
	sprite.modulate = cursor_settings[type]["color"]
	if type == "hex":
		var loaded: HexType = load("res://resources/HexTypes/%s.tres" % subtype)
		if !loaded:
			sprite.texture = (load("res://resources/HexTypes/delete.tres") as HexType).cursor_sprite
			return
		sprite.texture = loaded.cursor_sprite
	elif type == "object" && subtype == "settlement":
		var loaded := load("res://sprites/objects/settlement/woodRing.png")
		if !loaded:
			sprite.texture = (load("res://resources/HexTypes/delete.tres") as HexType).cursor_sprite
			return
		sprite.texture = loaded
	elif type == "test":
		sprite.texture = (load("res://resources/HexTypes/delete.tres") as HexType).cursor_sprite
	else:
		sprite.texture = (load("res://resources/HexTypes/delete.tres") as HexType).cursor_sprite

	
	
