extends Node

class_name World

@onready var map_service: MapService = $"../MapService"

@export var hex_scene: PackedScene
@export var settlement_scene: PackedScene

func _ready() -> void:
	#generate_grid(30,15)
	print(map_service.load_from_file("res://maps/bleh.json"))
	
	generate_grid(map_service.world_dict)
	
func hex_clicked(hex: Hex):
	print("%s, %s" % [hex.q, hex.r])
	#map_service.update_hex_type()
	
	
#region World Generation from data
func generate_grid(world_dict: Dictionary) -> void:
	for r: int in len(world_dict["map_data"]):
		if world_dict["map_data"][r].is_empty():
			continue
		world_dict[r] = {}
		for q: int in len(world_dict["map_data"][r]):
			if world_dict["map_data"][r][q].is_empty():
				continue
			var hex: Hex = place_hex(world_dict["map_data"][r][q], r, q)
			if world_dict["map_data"][r][q].has("settlement"):
				place_settlement(world_dict["map_data"][r][q]["settlement"],hex , r, q)
			
func place_hex(hex_data: Dictionary, r: int, q: int) -> Hex:
	var hex: Hex = hex_scene.instantiate()
	add_child(hex)
	hex.world = self
	hex.q = q
	hex.r = r 
	hex.name = "Hex (r %s, q %s)" % [r,q] 
	hex.set_hex_type(hex_data["hex_type"])
	hex_data["ref"] = hex
	return hex
	
func place_settlement(settlement_data: Dictionary, hex: Hex, r: int, q: int):
	var settlement = settlement_scene.instantiate()
	hex.add_child(settlement)
	(settlement as Settlement).settlement_data.deserialize(settlement_data)
	settlement_data['ref'] = settlement

func place_decor(decor_data: Dictionary, r: int, q: int):
	print("todo")

func place_unit(unit_data: Dictionary, r: int, q: int):
	print("todo")
#endregion
