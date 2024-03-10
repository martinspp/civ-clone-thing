extends Node

class_name WorldManager

@onready var map_service: MapService = $"../MapService"

@export var hex_scene: PackedScene
@export var settlement_scene: PackedScene

@onready var hexes: Node = Node.new()
@onready var rivers: Node = Node.new()

func _ready() -> void:
	GameStateService.world_manager = self
	hexes.name = "Hexes"
	rivers.name = "Rivers"
	add_child(hexes)
	add_child(rivers)
	#generate_grid(30,15)
	print(map_service.load_from_file("res://maps/bleh.json"))
	#map_service.world_dict["map_data"] = map_service.generate_land(20,20)
	generate_grid(map_service.world_dict)
	generate_rivers(map_service.world_dict)
	
func hex_clicked(hex: Hex):
	print("%s, %s" % [hex.q, hex.r])
	#map_service.update_hex_type()
	
	
#region World Generation from data
func generate_grid(world_dict: Dictionary) -> void:
	for r: int in len(world_dict["map_data"])-1:
		if world_dict["map_data"][r].is_empty():
			continue
		world_dict[r] = {}
		for q: int in len(world_dict["map_data"][r])-1:
			if world_dict["map_data"][r][q].is_empty():
				continue
			var hex: Hex = place_hex(world_dict["map_data"][r][q], r, q)
			if world_dict["map_data"][r][q].has("settlement"):
				place_settlement(world_dict["map_data"][r][q]["settlement"],hex , r, q)
			
func place_hex(hex_data: Dictionary, r: int, q: int) -> Hex:
	var hex: Hex = hex_scene.instantiate()
	hexes.add_child(hex)
	hex.world = self
	hex.q = q
	hex.r = r 
	hex.name = "Hex (r %s, q %s)" % [r,q] 
	hex.set_hex_type(hex_data["hex_type"])
	hex_data["ref"] = hex
	return hex
	
func place_settlement(settlement_data: Dictionary, hex: Hex, r: int, q: int) -> void:
	var settlement = settlement_scene.instantiate()
	hex.add_child(settlement)
	(settlement as Settlement).settlement_data.deserialize(settlement_data)
	settlement_data['ref'] = settlement

func generate_rivers(world_dict: Dictionary):
	for r: int in len(world_dict["map_data"])-1:
		if world_dict["map_data"][r].is_empty():
			continue
		for q: int in len(world_dict["map_data"][r])-1:
			if world_dict["map_data"][r][q].is_empty() || !world_dict["map_data"][r][q].has("rivers"):
				continue
		
			for side in Hex.side_flag.values():
				if int(world_dict["map_data"][r][q]["rivers"]) & side:
					add_river(world_dict["map_data"][r][q]["ref"], side)
					
func add_river(hex: Hex, side: Hex.side_flag):
	var river_line = Line2D.new()
	river_line.position = hex.position
	river_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	river_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	river_line.default_color = Color.LIGHT_BLUE
	river_line.add_point(Hex.border_set[Hex.border_pairs[Hex.get_side_index(side)][0]])
	river_line.add_point(Hex.border_set[Hex.border_pairs[Hex.get_side_index(side)][1]])
	rivers.add_child(river_line)
	
func place_decor(decor_data: Dictionary, r: int, q: int):
	print("todo")

func place_unit(unit_data: Dictionary, r: int, q: int):
	print("todo")
#endregion
