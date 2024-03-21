extends Node

# Data Service should be the only class that directly interacts with world_dict
class_name DataService

var world_dict: Dictionary
var axial_direction_vectors = [
	[-1,1],[0,1],[1,0],
	[1,-1],[0,-1],[-1,0]]
	
func _ready() -> void:
	GameStateService.data_service = self

#fuck this
func generate_land(_height: int, _width: int) -> Array:
	var height = _height + 1 # i dont know what im doing
	var width = _width
	var new_map_data := []
	new_map_data.resize(height)
	for r in range(height):
		new_map_data[r] = []
		new_map_data[r].resize(width+1+width/2) # dont lower otherwise this gets weird
		new_map_data[r].fill({}) # to fill in null, dont use this because its the same dict by ref
		for q in range(width):
			var new_q = q + floor((height-1-r)/2) # ?????
			new_map_data[r][new_q] = {}
			new_map_data[r][new_q]["hex_type"] = "water"
	return new_map_data

func load_from_file(path: String) -> bool:
	var file: String = FileAccess.get_file_as_string(path)
	world_dict = JSON.parse_string(file)
	if world_dict == null:
		return false
	return true
	
func save_map(path: String) -> void:
	var file: FileAccess = FileAccess.open(path,FileAccess.WRITE)
	var world_dict_clean :Dictionary = world_dict.duplicate(true)
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
	
#region settlement
func add_settlement(hex: Hex, settlement: Settlement) -> void:
	if world_dict["map_data"][hex.r][hex.q].has("settlement"):
		print("Already has settlement")
		return
	if hex.hex_type.settleable == true:
		if settlement == null:
			world_dict["map_data"][hex.r][hex.q]["settlement"] = SettlementData.default_data()
		else:
			world_dict["map_data"][hex.r][hex.q]["settlement"]['ref'] = settlement
			world_dict["map_data"][hex.r][hex.q]["settlement"] = settlement.settlement_data.serialize()	
	else:
		print("Cant settle on %s" % hex.hex_type.data_name)
	GameStateService.world_manager.refresh_hex_settlement(world_dict, hex)

func remove_settlement(hex: Hex) -> void:
	if world_dict["map_data"][hex.r][hex.q].has("settlement"):
		world_dict["map_data"][hex.r][hex.q]["settlement"]["ref"].queue_free()
		world_dict["map_data"][hex.r][hex.q].erase("settlement")
		GameStateService.world_manager.refresh_hex_settlement(world_dict, hex)
		
func get_settlement_by_hex(hex: Hex) -> Settlement:
	if world_dict["map_data"][hex.r][hex.q].has("settlement"):
		return world_dict["map_data"][hex.r][hex.q]['settlement']['ref']
	else:
		return null

func update_settlement_data(settlement: Settlement) -> void:
	world_dict["map_data"][settlement.parent_hex.r][settlement.parent_hex.q]["settlement"] = settlement.settlement_data.serialize()
#endregion
#region river
func add_river(hex: Hex, side: Hex.side_flag) -> bool:
	if hex.rivers & side:
		print("River already set")
		return false
	else:
		hex.rivers = hex.rivers | side
		world_dict["map_data"][hex.r][hex.q]["rivers"] = hex.rivers
		var neighbour_hex: Hex = get_neighbouring_hex(world_dict["map_data"][hex.r][hex.q]["ref"],side)
		if neighbour_hex:
			neighbour_hex.rivers = neighbour_hex.rivers | 2**Hex.inverse_side_lut[Hex.get_side_index(side)]
			world_dict["map_data"][neighbour_hex.r][neighbour_hex.q]["rivers"] = neighbour_hex.rivers
	return true
	
func remove_river(hex: Hex, side: Hex.side_flag) -> void:
	hex.rivers = ~(~hex.rivers | side)
	world_dict["map_data"][hex.r][hex.q]["rivers"] = hex.rivers
	var neighbour_hex: Hex = get_neighbouring_hex(world_dict["map_data"][hex.r][hex.q]["ref"],side)
	if neighbour_hex:
		neighbour_hex.rivers = ~(~neighbour_hex.rivers | 2**Hex.inverse_side_lut[Hex.get_side_index(side)])
		world_dict["map_data"][neighbour_hex.r][neighbour_hex.q]["rivers"] = neighbour_hex.rivers
#endregion

func get_neighbouring_hex(hex: Hex, side: Hex.side_flag) -> Hex:
	var side_coord := Hex.get_side_index(side)
	var new_r: int = hex.r+axial_direction_vectors[side_coord][0]
	var new_q: int = hex.q+axial_direction_vectors[side_coord][1]
	if world_dict["map_data"][new_r][new_q].has("ref"):
		return world_dict["map_data"][new_r][new_q]["ref"]
	return null

func add_unit(hex: Hex, unit: Unit) -> void:
	pass
	
func _on_editor_ui_map_save_load(action: String) -> void:
	if action == "save":
		save_map("res://maps/bleh.json")
	if action == "load":
		load_from_file("res://maps/bleh.json")
		load_players()
		GameStateService.world_manager.start_generation(world_dict)
		GameStateService.editor_service.player_menu.populate_list()
		

func load_players() -> void:
	for player in world_dict["player_data"]["players"]:
		var new_player = Player.new("foobar", null, null)
		new_player.deserialize(world_dict["player_data"]["players"][player])
		add_update_player(new_player)
	print(world_dict["player_data"]["players"])


func add_update_player(player: Player) -> void:
	world_dict["player_data"]["players"][str(player.id)] = player.serialize()
	PlayEventBus.player_list_updated.emit()

func remove_player(player_id: int) -> void:
	world_dict["player_data"]["players"].erase(str(player_id))
	PlayEventBus.player_list_updated.emit()

func get_player_by_id(player_id: int) -> Player:
	if world_dict["player_data"]["players"].has(str(player_id)):
		return world_dict["player_data"]["players"][str(player_id)]["ref"]
	else: 
		return null

func is_player_exist(player: Player) -> bool:
	if player:
		return world_dict["player_data"]["players"].has(str(player.id))
	else:
		return false

func get_all_players() -> Array[Player]:
	var ret: Array[Player] = []
	for p in world_dict["player_data"]["players"]:
		ret.append(world_dict["player_data"]["players"][p]["ref"])
	return ret