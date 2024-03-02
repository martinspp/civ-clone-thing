extends Node

class_name World

@onready var map_service: MapService = $"../MapService"

@export var hex_scene: PackedScene

func _ready() -> void:
	#generate_grid(30,15)
	print(map_service.load_from_file("res://maps/bleh.json"))
	
	generate_grid(map_service.world_dict)
	
func hex_clicked(hex: Hex):
	print("%s, %s" % [hex.q, hex.r])
	map_service.delete_hex(hex)
	
func generate_grid(world_dict: Dictionary) -> void:
	for r: int in len(world_dict["map_data"]):
		if world_dict["map_data"][r].is_empty():
			continue
		world_dict[r] = {}
		for q: int in len(world_dict["map_data"][r]):
			if world_dict["map_data"][r][q].is_empty():
				continue
			var hex: Hex = hex_scene.instantiate()
			add_child(hex)
			hex.world = self
			hex.q = q
			hex.r = r 
			hex.name = "Hex (r %s, q %s)" % [r,q] 
			hex.set_hex_type(world_dict["map_data"][r][q]["hex_type"])
			world_dict["map_data"][r][q]["ref"] = hex
			(hex.sprite as CanvasItem).z_index = r
