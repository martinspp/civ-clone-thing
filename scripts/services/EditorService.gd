extends Node

class_name EditorService
@export var hex_scene: PackedScene
@export var settlement_scene: PackedScene
@export var editor_ui_scene: PackedScene
@export var player_menu_scene: PackedScene
@export var debug_lines: Line2D

var editor_ui: EditorUI
var player_menu: PlayerMenu
static var cursor: HexCursor
static var selected_type: String = "hex"
static var selected_subtype: String = "grass"
static var selected_settlement: Settlement

func _ready() -> void:
	GameStateService.editor_service = self
	cursor = hex_scene.instantiate()
	GameStateService.world_manager.hexes.add_child(cursor)
	cursor.set_cursor_type(selected_type, selected_subtype)
	editor_ui = editor_ui_scene.instantiate()
	$"../CanvasLayer".add_child(editor_ui)

	player_menu = player_menu_scene.instantiate()
	$"../CanvasLayer".add_child(player_menu)
	
func move_editor_cursor(move_to_hex: Hex) -> void:
	cursor.q = move_to_hex.q
	cursor.r = move_to_hex.r
	
func _on_editor_ui_type_changed(type: String, sub_type: String = "") -> void:
	cursor.set_cursor_type(type, sub_type)
	selected_type = type
	selected_subtype = sub_type

func hex_clicked(hex: Hex, event: InputEvent) -> void:
	if selected_type == "object" && selected_subtype == "settlement":
		GameStateService.data_service.add_settlement(hex, null)
	elif selected_type == "action" && selected_subtype == "select":
		selected_settlement = GameStateService.data_service.get_settlement_by_hex(hex)
		if selected_settlement != null:
			editor_ui.set_settlement_info(selected_settlement)
	elif selected_type == "object" && selected_subtype == "river":
		var sextant_clicked: Hex.side_flag = hex.get_sextant_clicked(event)
		if GameStateService.data_service.add_river(hex, sextant_clicked):
			GameStateService.world_manager.add_river(hex, sextant_clicked)
	elif selected_type == "unit":
		pass
	elif selected_type == "hex":
		GameStateService.data_service.update_hex_type(hex, selected_subtype)
	elif selected_type == "test" && selected_subtype == "ring":
		debug_lines.closed = true
		highlight_hexes(GameStateService.data_service._axial_to_hex_array((Axial.ring(hex.axial,5))))
	elif selected_type == "test" && selected_subtype == "spiral":
		debug_lines.closed = false
		highlight_hexes(GameStateService.data_service._axial_to_hex_array((Axial.spiral(hex.axial,10))))
		

		

func hex_alt_clicked(hex: Hex, event: InputEvent) -> void:
	if selected_type == "object" && selected_subtype == "settlement":
		GameStateService.data_service.remove_settlement(hex)
		GameStateService.world_manager.refresh_hex_settlement(hex)
	elif selected_type == "object" && selected_subtype == "river":
		var sextant_clicked: Hex.side_flag = hex.get_sextant_clicked(event)
		GameStateService.data_service.remove_river(hex, sextant_clicked)
		GameStateService.world_manager.refresh_hex_rivers(hex)
	

func _exit_tree() -> void:
	GameStateService.editor_service = null
	cursor.queue_free()
	editor_ui.queue_free()
	
	
func highlight_hexes(hexes: Array[Hex]) -> void:
	debug_lines.clear_points()
	for hex in hexes:
		#if hex.hex_type.data_name == "water":
		#	continue
		debug_lines.add_point(hex.global_position)