extends Control

class_name EditorUI

var type_selected: HexType

@onready var settlement_data: HBoxContainer = $VBoxContainer/settlement_data

signal type_changed(String)
signal map_save_load(String)
signal start_game()

func _ready() -> void:
	type_changed.connect(GameStateService.editor_service._on_editor_ui_type_changed)
	map_save_load.connect(GameStateService.map_service._on_editor_ui_map_save_load)
	start_game.connect(GameStateService.start_game)
	
func _on_type_selected(type: String) -> void:
	type_changed.emit(type)
	
func _on_map_action(action: String) -> void:
	map_save_load.emit(action)

func _start_game_action() -> void:
	start_game.emit()

func set_settlement_info(settlement: Settlement) -> void:
	settlement_data.set_visible(true)
	$VBoxContainer/settlement_data/VBoxContainer/s_name.text = settlement.settlement_data.settlement_name
	$VBoxContainer/settlement_data/VBoxContainer/s_pop.text = str(settlement.settlement_data.pop)
	$VBoxContainer/settlement_data/VBoxContainer2/s_progress.text = str(settlement.settlement_data.pop_progress)
	$VBoxContainer/settlement_data/VBoxContainer2/s_influence.text = str(settlement.settlement_data.influence_range)

func _close_settlement_data() -> void:
	settlement_data.set_visible(false)
	
func _process(delta: float) -> void:
	pass
	#var cameratrans := get_viewport().get_camera_2d().get_transform()
	#$VBoxContainer/VBoxContainer/HBoxContainer/globalMouse.text = str(get_global_mouse_position() cameratrans)
	#$VBoxContainer/VBoxContainer/HBoxContainer2/globalMouse.text = str(GameStateService.adjusted_mouse_pos)
	#$VBoxContainer/VBoxContainer/HBoxContainer3/globalMouse
