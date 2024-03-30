extends Resource

class_name SettlementData

var id := randi()
var owned_player: Player 
@export var settlement_name: String = "New City"
@export var pop: int = 0
@export var pop_progress: float = 0.0
@export var influence_range: int = 1

#either Building or Unit
var production_dict: Dictionary = {}
var current_production: String = ""

var ref: Settlement

signal data_updated()

func serialize() -> Dictionary:
	var player_id: int
	if owned_player:
		player_id = owned_player.id
	else:
		player_id = -1 

	return {
		"settlement_name" = settlement_name,
		"pop" = pop,
		"pop_progress" = pop_progress,
		"influence_range" = influence_range,
		"id" = id,
		"owned_player_id" = player_id,
		"ref" = ref,
		"productions" = production_dict,
	}
	
func deserialize(data: Dictionary) -> void:
	settlement_name = data["settlement_name"]
	pop = data["pop"]
	pop_progress = data["pop_progress"]
	influence_range = data["influence_range"]
	id = data["id"]	
	if data.has("owned_player_id"):
		if data["owned_player_id"] != -1:
			owned_player = GameStateService.data_service.get_player_by_id(data["owned_player_id"])
	if data.has('productions'):
		production_dict = data["productions"]
	else:
		production_dict = {}
		
	data_updated.emit()

func get_production_progress(name: String) -> float:
	if production_dict.has(name):
		return production_dict[name]
	else:
		return 0.0

## returns new production progress, return should always be handled
func update_production_progress(name: String, progress: float) -> float:
	if get_production_progress(name) == 0.0:
		production_dict[name] = progress
	else:
		production_dict[name] += progress
	
	if production_dict[name] >= 1.0:
	# production is done, remove and return 1.0
		production_dict.erase(name)
		return 1.0

	return production_dict[name]


static func default_data() -> Dictionary:
	return {
		"id"= randi(),
		"settlement_name" = "New City",
		"pop" = 0,
		"pop_progress" = 0.0,
		"influence_range" = 1,
		"owned_player_id" = -1
	}

