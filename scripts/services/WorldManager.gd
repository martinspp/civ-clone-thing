extends Node

class_name WorldManager

@export var hex_scene: PackedScene
@export var settlement_scene: PackedScene

@onready var hexes: Node = Node.new()
@onready var rivers: Node = Node.new()
@onready var units: Node = Node.new()
@onready var decors: Node = Node.new()

@onready var astar := AStar2D.new()

var loaded = false

func _ready() -> void:
	GameStateService.world_manager = self
	Hex.world = self
	hexes.name = "Hexes"
	rivers.name = "Rivers"
	units.name = "Units"
	decors.name = "Decors"
	add_child(hexes)
	add_child(rivers)
	add_child(units)
	add_child(decors)
	

func start_generation(world_dict: Dictionary) -> void:
	generate_grid(world_dict)
	#apply_on_all_hexes(world_dict, refresh_hex_rivers)
	generate_rivers(world_dict)
	loaded = true
	
func hex_clicked(hex: Hex):
	print("%s, %s" % [hex.q, hex.r])
	
#region World Generation from data
func generate_grid(world_dict: Dictionary) -> void:
	clear_grid(world_dict)
	for r: int in len(world_dict["map_data"])-1:
		if world_dict["map_data"][r].is_empty():
			continue
		world_dict[r] = {}
		for q: int in len(world_dict["map_data"][r])-1:
			if world_dict["map_data"][r][q].is_empty():
				continue
			var hex: Hex = place_hex(world_dict["map_data"][r][q], r, q)
			refresh_hex(world_dict, hex)
			
func apply_on_all_hexes(world_dict:Dictionary, function: Callable):
	for r: int in len(world_dict["map_data"])-1:
		if world_dict["map_data"][r].is_empty():
			continue
		for q: int in len(world_dict["map_data"][r])-1:
			if world_dict["map_data"][r][q].is_empty():
				continue
			if world_dict["map_data"][r][q].has("ref"):
				function.call(world_dict, world_dict["map_data"][r][q]["ref"])

func place_hex(hex_data: Dictionary, r: int, q: int) -> Hex:
	var hex: Hex = hex_scene.instantiate()
	hexes.add_child(hex)
	hex.q = q
	hex.r = r 
	hex.name = "Hex (r %s, q %s)" % [r,q] 
	if hex_data.has("rivers"):
		hex.rivers = hex_data["rivers"]
	hex_data["ref"] = hex
	return hex
	
#region hex refreshing
func refresh_hex(world_dict: Dictionary, hex: Hex):
	hex.set_hex_type_by_string(world_dict["map_data"][hex.r][hex.q]["hex_type"]) 
	refresh_hex_settlement(world_dict, hex)
	
func refresh_hex_settlement(world_dict: Dictionary, hex: Hex):
	if world_dict["map_data"][hex.r][hex.q].has("settlement"):
		print(world_dict["map_data"][hex.r][hex.q]["settlement"])
		# Fresh settlement wont have ref
		if !world_dict["map_data"][hex.r][hex.q]["settlement"].has("ref") || (
			world_dict["map_data"][hex.r][hex.q]["settlement"].has("ref") && typeof(world_dict["map_data"][hex.r][hex.q]["settlement"]["ref"]) == TYPE_STRING):
			world_dict["map_data"][hex.r][hex.q]["settlement"]["ref"] = place_settlement(world_dict["map_data"][hex.r][hex.q]["settlement"], hex)
			

func refresh_hex_rivers(world_dict: Dictionary, hex: Hex):
	for river in rivers.get_children():
		if river.get_meta("q") == hex.q && river.get_meta("r") == hex.r:
			river.queue_free()
	for side in Hex.side_flag.values():
		var n_hex: Hex = GameStateService.data_service.get_neighbouring_hex(hex, side)
		if n_hex:
			for river in rivers.get_children():
				if river.get_meta("q") == n_hex.q && river.get_meta("r") == n_hex.r && (river.get_meta("side") == 2** Hex.inverse_side_lut[Hex.get_side_index(side)]):
					river.queue_free()
	for side in Hex.side_flag.values():
		if world_dict["map_data"][hex.r][hex.q].has("rivers"):
			if int(world_dict["map_data"][hex.r][hex.q]["rivers"]) & side:
				add_river(world_dict["map_data"][hex.r][hex.q]["ref"], side)

func place_settlement(settlement_data: Dictionary, hex: Hex) -> Settlement:
	var settlement: Settlement = settlement_scene.instantiate()
	hex.add_child(settlement)
	settlement.settlement_data.deserialize(settlement_data)
	return settlement

func generate_rivers(world_dict: Dictionary):
	for river in rivers.get_children():
		river.queue_free()
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
	river_line.set_meta("q", hex.q)
	river_line.set_meta("r", hex.r)
	river_line.set_meta("side", side)
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


func clear_grid(world_dict: Dictionary) -> void:
	apply_on_all_hexes(world_dict,remove_hex)
	for n in rivers.get_children():
		n.queue_free()
		rivers.remove_child(n)
	loaded = false

func remove_hex(world_dict: Dictionary, hex: Hex):
	hex.queue_free()
