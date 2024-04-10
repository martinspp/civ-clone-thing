extends Node2D

class_name HexDecor

@onready var decor_count :int = randi_range(5,10)
@export var bush_grass: Texture2D
@export var water_wave: Texture2D
func _ready() -> void:
	pass

func update_hex_type_decor(hex_type: String) -> void:
	clear_hex_type_decor()
	if hex_type == "grass":
		spawn_grass()
	if hex_type == "water":
		spawn_wave()

func clear_hex_type_decor() -> void:
	for i in get_children():
		if i.get_meta('type') == 'hex_type':
			i.queue_free()
			
func spawn_grass() -> void:
	for i in decor_count:
		var grass := Sprite2D.new()
		grass.texture = bush_grass
		add_child(grass)
		grass.set_meta("type", "hex_type")
		grass.position = get_random_point()

func spawn_wave() -> void:
	for i in decor_count:
		var wave := Sprite2D.new()
		wave.texture = water_wave
		add_child(wave)
		wave.set_meta("type", "hex_type")
		wave.position = get_random_point()

func get_random_point() -> Vector2:
	var r: float= 65 * sqrt(randf_range(0,1))
	var theta: float = randf_range(0,1) * 2 * PI
	return Vector2(r * cos(theta), r * sin(theta))