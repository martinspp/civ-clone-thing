extends Node2D

class_name HexHighlighter

@export var higlight_color: Color = Color(0, 0, 1, 0.2)
@export var hex_texture: Texture2D

func update_hexes(hexes: Array[Hex]) -> void:
	var children: Array[Node] = get_children()
	for child in children:
		child.queue_free()
	
	for hex in hexes:
		var sprite : Sprite2D = Sprite2D.new()
		sprite.texture = hex_texture
		sprite.position = global_position-hex.global_position + Vector2(0,23.027)
		sprite.scale = Vector2(1.969,1.969)
		sprite.modulate = higlight_color
		add_child(sprite)

