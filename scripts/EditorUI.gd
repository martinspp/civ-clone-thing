extends Control

class_name EditorUI

var type_selected: HexType

@onready var settlement_data: HBoxContainer = $VBoxContainer/settlement_data

signal type_changed(String)
signal map_save_load(String)

func _ready() -> void:
	type_changed.connect(GameStateService.editor_service._on_editor_ui_type_changed)
	map_save_load.connect(GameStateService.map_service._on_editor_ui_map_save_load)
	
func _on_type_selected(type: String) -> void:
	type_changed.emit(type)
	
func _on_map_action(action: String) -> void:
	map_save_load.emit(action)


func set_settlement_info(settlement: Settlement) -> void:
	settlement_data.set_visible(true)
	$VBoxContainer/settlement_data/VBoxContainer/s_name.text = settlement.settlement_data.settlement_name
	$VBoxContainer/settlement_data/VBoxContainer/s_pop.text = str(settlement.settlement_data.pop)
	$VBoxContainer/settlement_data/VBoxContainer2/s_progress.text = str(settlement.settlement_data.pop_progress)
	$VBoxContainer/settlement_data/VBoxContainer2/s_influence.text = str(settlement.settlement_data.influence_range)

func _close_settlement_data() -> void:
	settlement_data.set_visible(false)
