extends Control

var type_selected: HexType

signal type_changed(String)
signal map_save_load(String)

func _on_type_selected(type: String) -> void:
	type_changed.emit(type)
	
func _on_map_action(action: String) -> void:
	map_save_load.emit(action)
