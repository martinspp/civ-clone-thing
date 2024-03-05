extends Node

class_name EditorService
@export var world: World
@export var hex_scene: PackedScene
@export var settlement_scene: PackedScene
@export var editor_ui_scene: PackedScene
var editor_ui: EditorUI
static var cursor: HexCursor
static var selected_type: String = "grass"
static var selected_settlement: Settlement

func _ready() -> void:
	cursor = hex_scene.instantiate()
	world.add_child(cursor)
	cursor.set_cursor_type(selected_type)
	GameStateService.editor_service = self
	editor_ui = editor_ui_scene.instantiate()
	$"../CanvasLayer".add_child(editor_ui)

func move_editor_cursor(move_to_hex: Hex) -> void:
	cursor.q = move_to_hex.q
	cursor.r = move_to_hex.r
	
func _on_editor_ui_type_changed(type: String) -> void:
		cursor.set_cursor_type(type)
		selected_type = type

func hex_clicked(hex: Hex):
	if selected_type == "settlement":
		GameStateService.map_service.add_new_settlement(hex)
	elif selected_type == "select":
		var selected_settlement = GameStateService.map_service.get_settlement_by_hex(hex)
		editor_ui.set_settlement_info(selected_settlement)
	else:
		GameStateService.map_service.update_hex_type(hex, selected_type)

func hex_alt_clicked(hex: Hex):
	if selected_type == "settlement":
		GameStateService.map_service.remove_settlement(hex)
	
	
func _exit_tree() -> void:
	GameStateService.editor_service = null
	cursor.queue_free()
	editor_ui.queue_free()
	
	
