extends Node2D

class_name FowHider

func reveal() -> void:
	get_parent().visible = true
	if get_parent() is Hex:
		var hex :Hex = get_parent()
		
	#TODO check if is hex and has a river

static func hide_all() -> void:
	var hiders :Array[Node] = GameStateService.get_tree().get_nodes_in_group("FowHiders")

	#for objects that get generated without FowHider but still need to be hidden (rivers)
	#Revealing needs to be checked by object basis
	var hiders_single :Array[Node] = GameStateService.get_tree().get_nodes_in_group("FowHidersSingle")

	for hider in hiders:
		hider.get_parent().visible = false
		if hider.get_parent() is Hex:
			hider.get_parent().update_pathing()
	
	for hider in hiders_single:
		hider.visible = false
