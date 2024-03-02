extends Node

@export var world: World
@export var hex_scene: PackedScene
@export var editor_ui: Container
var cursor: Hex


func _ready() -> void:
	cursor = hex_scene.instantiate()
	world.add_child(cursor)
	cursor.q = -2
	cursor.r = -2 

func _on_editor_ui_type_changed(type: String) -> void:
	cursor.set_hex_type(type)
	
func _process(delta: float) -> void:
	pass
	
