extends Control

var type_selected: HexType

signal type_changed(String)

func _on_type_selected(type: String) -> void:
	type_changed.emit(type)
