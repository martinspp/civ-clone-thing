extends Node

class_name WorldManager

@export var hex_scene: PackedScene
@export var settlement_scene: PackedScene

@onready var hexes: Node = Node.new()
@onready var rivers: Node = Node.new()
@onready var units: Node = Node.new()
@onready var decors: Node = Node.new()

@onready var astar := AStar2D.new()
@onready var astar_dict: Dictionary = {}

var loaded : bool= false

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
	

func start_generation() -> void:
	astar.clear()
	generate_grid()
	#apply_on_all_hexes(world_dict, refresh_hex_rivers)
	generate_rivers()
	apply_on_all_hexes(connect_neighbours)

	loaded = true
	
func hex_clicked(hex: Hex) -> void: 	
	print("%s, %s" % [hex.q, hex.r])
	
#region World Generation from data
func generate_grid() -> void:
	clear_grid()
	for r: int in len(DataService.world_dict["map_data"])-1:
		if DataService.world_dict["map_data"][r].is_empty():
			continue
		DataService.world_dict[r] = {}
		for q: int in len(DataService.world_dict["map_data"][r])-1:
			if DataService.world_dict["map_data"][r][q].is_empty():
				continue
			var hex: Hex = place_hex(r, q)
			refresh_hex(hex)
	
			
func apply_on_all_hexes(function: Callable) -> void:
	for r: int in len(DataService.world_dict["map_data"])-1:
		if DataService.world_dict["map_data"][r].is_empty():
			continue
		for q: int in len(DataService.world_dict["map_data"][r])-1:
			if DataService.world_dict["map_data"][r][q].is_empty():
				continue
			elif DataService.world_dict["map_data"][r][q].has("ref"):
				function.call(DataService.world_dict["map_data"][r][q]["ref"])

func place_hex(r: int, q: int) -> Hex:
	var hex: Hex = hex_scene.instantiate()
	hexes.add_child(hex)
	hex.q = q
	hex.r = r 
	if DataService.world_dict["map_data"][r][q].has("rivers"):
		hex.rivers = DataService.world_dict["map_data"][r][q]["rivers"]
	DataService.world_dict["map_data"][r][q]["ref"] = hex
	return hex

func connect_neighbours(hex: Hex) -> void:
	for neighbour: Hex in GameStateService.data_service.get_all_neighbouring_hexes(hex):
		astar.connect_points(hex.get_meta("astar_id"), neighbour.get_meta("astar_id"), true)
#endregion
#region hex refreshing
func refresh_hex(hex: Hex) -> void:
	hex.set_hex_type_by_string(DataService.world_dict["map_data"][hex.r][hex.q]["hex_type"]) 
	refresh_hex_settlement(hex)
	
func refresh_hex_settlement(hex: Hex) -> void:
	if DataService.world_dict["map_data"][hex.r][hex.q].has("settlement"):
		# Fresh settlement wont have ref
		if !DataService.world_dict["map_data"][hex.r][hex.q]["settlement"].has("ref") || (
			DataService.world_dict["map_data"][hex.r][hex.q]["settlement"].has("ref") && typeof(DataService.world_dict["map_data"][hex.r][hex.q]["settlement"]["ref"]) == TYPE_STRING):
			DataService.world_dict["map_data"][hex.r][hex.q]["settlement"]["ref"] = place_settlement(DataService.world_dict["map_data"][hex.r][hex.q]["settlement"], hex)
			

func refresh_hex_rivers(hex: Hex) -> void:
	for river in rivers.get_children():
		if river.get_meta("q") == hex.q && river.get_meta("r") == hex.r:
			river.queue_free()
	for side: int in Hex.side_flag.values():
		var n_hex: Hex = GameStateService.data_service.get_neighbouring_hex(hex, side)
		if n_hex:
			for river in rivers.get_children():
				if river.get_meta("q") == n_hex.q && river.get_meta("r") == n_hex.r && (river.get_meta("side") == 2** Hex.inverse_side_lut[Hex.get_side_index(side)]):
					river.queue_free()
	for side: int in Hex.side_flag.values():
		if DataService.world_dict["map_data"][hex.r][hex.q].has("rivers"):
			if int(DataService.world_dict["map_data"][hex.r][hex.q]["rivers"]) & side:
				add_river(DataService.world_dict["map_data"][hex.r][hex.q]["ref"], side)

func place_settlement(settlement_data: Dictionary, hex: Hex) -> Settlement:
	var settlement: Settlement = settlement_scene.instantiate()
	hex.add_child(settlement)
	settlement.settlement_data.deserialize(settlement_data)
	return settlement

func generate_rivers() -> void:
	for river in rivers.get_children():
		river.queue_free()
	for r: int in len(DataService.world_dict["map_data"])-1:
		if DataService.world_dict["map_data"][r].is_empty():
			continue
		for q: int in len(DataService.world_dict["map_data"][r])-1:
			if DataService.world_dict["map_data"][r][q].is_empty() || !DataService.world_dict["map_data"][r][q].has("rivers"):
				continue
		
			for side: int in Hex.side_flag.values():
				if int(DataService.world_dict["map_data"][r][q]["rivers"]) & side:
					add_river(DataService.world_dict["map_data"][r][q]["ref"], side)
					
func add_river(hex: Hex, side: Hex.side_flag) -> void:
	var river_line := Line2D.new()
	river_line.set_meta("q", hex.q)
	river_line.set_meta("r", hex.r)
	river_line.set_meta("side", side)
	river_line.position = hex.position
	river_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	river_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	river_line.default_color = Color.LIGHT_BLUE
	river_line.add_point(Hex.border_set[Hex.border_pairs[Hex.get_side_index(side)][0]])
	river_line.add_point(Hex.border_set[Hex.border_pairs[Hex.get_side_index(side)][1]])
	river_line.add_to_group("FowHidersSingle")
	rivers.add_child(river_line)
	
func place_decor(decor_data: Dictionary, r: int, q: int) -> void:
	print("todo")

func place_unit(unit_data: Dictionary, r: int, q: int) -> void:
	print("todo")
#endregion


func clear_grid() -> void:
	for h in hexes.get_children():
		if h is Hex:
			h.queue_free()
	for n in rivers.get_children():
		n.queue_free()
		rivers.remove_child(n)
	for u in units.get_children():
		u.queue_free()
		
	loaded = false

func remove_hex(hex: Hex) -> void:
	hex.queue_free()