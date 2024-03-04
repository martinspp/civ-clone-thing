extends Node

class_name MapService

var world_dict: Dictionary

func _ready() -> void:
	GameStateService.map_service = self

func load_from_file(path: String) -> bool:
	var file: String = FileAccess.get_file_as_string(path)
	world_dict = JSON.parse_string(file)
	if world_dict == null:
		return false
	return true
	
func save_map(path: String) -> void:
	var file: FileAccess = FileAccess.open(path,FileAccess.WRITE)
	var world_dict_clean = world_dict.duplicate(true)
	# Need to remove godot references from dict
	for r: int in len(world_dict_clean["map_data"]):
		if world_dict["map_data"][r].is_empty():
			continue
		world_dict[r] = {}
		for q: int in len(world_dict_clean["map_data"][r]):
			if world_dict_clean["map_data"][r][q].is_empty():
				continue
			world_dict_clean["map_data"][r][q].erase("ref")
	file.store_string(JSON.stringify(world_dict_clean))
	file.close()
	
func delete_hex(hex: Hex) -> void: 
	(world_dict["map_data"][hex.r][hex.q]["ref"] as Hex).delete()
	world_dict["map_data"][hex.r][hex.q].clear()
	
func update_hex_type(hex: Hex, hex_type: String) -> void:
	(world_dict["map_data"][hex.r][hex.q]["ref"] as Hex).set_hex_type(hex_type)
	world_dict["map_data"][hex.r][hex.q]["hex_type"] = hex_type

func add_settlement(hex: Hex, settlement: Settlement):
	world_dict["map_data"][hex.r][hex.q]["settlement"] = settlement.settlement_data.serialize()
	world_dict["map_data"][hex.r][hex.q]["settlement"]['ref'] = settlement
	
	#world_dict["map_data"][hex.r][hex.q]["settlement"]['ref'] = settlement
	#world_dict["map_data"][hex.r][hex.q]["settlement"]['settlement_name'] = settlement.settlement_name
	#world_dict["map_data"][hex.r][hex.q]["settlement"]['pop'] = settlement.pop
	#world_dict["map_data"][hex.r][hex.q]["settlement"]['pop_progress'] = settlement.pop_progress
	#world_dict["map_data"][hex.r][hex.q]["settlement"]['influence_range'] = settlement.influence_range
	

func _on_editor_ui_map_save_load(action: String) -> void:
	if action == "save":
		save_map("res://maps/bleh.json")
	if action == "load":
		load_from_file("res://maps/bleh.json")
