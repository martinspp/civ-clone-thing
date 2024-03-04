extends Node

class_name EditorService
@export var world: World
@export var hex_scene: PackedScene
@export var settlement_scene: PackedScene
@export var editor_ui: Container
static var cursor: HexCursor
static var selected_type: String = "grass"

func _ready() -> void:
	cursor = hex_scene.instantiate()
	world.add_child(cursor)
	cursor.set_cursor_type(selected_type)
	GameStateService.editor_service = self

func move_editor_cursor(move_to_hex: Hex) -> void:
	cursor.q = move_to_hex.q
	cursor.r = move_to_hex.r
	
func _on_editor_ui_type_changed(type: String) -> void:
		cursor.set_cursor_type(type)
		selected_type = type

func hex_clicked(hex: Hex):
	if selected_type == "settlement":
		var new_settlement: Settlement = settlement_scene.instantiate()
		hex.add_child(new_settlement)
		GameStateService.map_service.add_settlement(hex, new_settlement)
	else:
		GameStateService.map_service.update_hex_type(hex, selected_type)
	
	
	
func _process(delta: float) -> void:
	pass
	
