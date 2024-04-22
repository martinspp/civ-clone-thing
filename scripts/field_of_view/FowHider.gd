extends Node2D

class_name FowHider

static func hide_all() -> void:
	var hiders :Array[Node] = GameStateService.get_tree().get_nodes_in_group("FowHiders")
	var hiders_single :Array[Node] = GameStateService.get_tree().get_nodes_in_group("FowHidersSingle")

	for hider in hiders:
		hider.get_parent().visible = false
	
	for hider in hiders_single:
		hider.visible = false
