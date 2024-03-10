extends Node

class_name EditorService
@export var hex_scene: PackedScene
@export var settlement_scene: PackedScene
@export var editor_ui_scene: PackedScene
var editor_ui: EditorUI
static var cursor: HexCursor
static var selected_type: String = "grass"
static var selected_settlement: Settlement

func _ready() -> void:
	cursor = hex_scene.instantiate()
	GameStateService.world_manager.hexes.add_child(cursor)
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

func hex_clicked(hex: Hex, event: InputEvent):
	if selected_type == "settlement":
		GameStateService.map_service.add_new_settlement(hex)
	elif selected_type == "select":
		var selected_settlement = GameStateService.map_service.get_settlement_by_hex(hex)
		editor_ui.set_settlement_info(selected_settlement)
	elif selected_type == "river":
		#print(hex.global_position.angle_to((event as InputEventMouse).global_position))
		var camera: Camera2D = get_viewport().get_camera_2d()
		var mouse_pos_relative_to_world: Vector2 = event.global_position + camera.position + camera.offset - get_viewport().size * 0.5
		var side_angle = rad_to_deg(hex.global_position.angle_to_point(mouse_pos_relative_to_world))+90 # 0 is horizontal right
		if side_angle < 0:
			side_angle += 359 # help
		var side_angle_snapped = snappedf(side_angle,30)
		if side_angle_snapped == 360:
			side_angle_snapped = 0 # i hate myself
		var side = floor(side_angle_snapped / 60)
		if GameStateService.map_service.add_river(hex, 2**(side)):
			GameStateService.world_manager.add_river(hex, 2**(side))
	else:
		GameStateService.map_service.update_hex_type(hex, selected_type)
		

func hex_alt_clicked(hex: Hex):
	if selected_type == "settlement":
		GameStateService.map_service.remove_settlement(hex)
	
	
func _exit_tree() -> void:
	GameStateService.editor_service = null
	cursor.queue_free()
	editor_ui.queue_free()
	
	
