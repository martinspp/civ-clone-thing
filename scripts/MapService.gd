extends Node

class_name MapService

var world_dict: Dictionary

func _ready() -> void:
	pass

func load_from_file(path: String) -> bool:
	var file: String = FileAccess.get_file_as_string(path)
	world_dict = JSON.parse_string(file)
	if world_dict == null:
		return false
	return true

func delete_hex(hex: Hex) -> void: 
	(world_dict["map_data"][hex.r][hex.q]["ref"] as Hex).delete()
	world_dict["map_data"][hex.r][hex.q].clear()
	print(world_dict)

