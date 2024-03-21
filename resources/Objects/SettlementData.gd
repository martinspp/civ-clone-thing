extends Resource

class_name SettlementData

var id := randi()
var owned_player: Player 
@export var settlement_name: String = "New City"
@export var pop: int = 0
@export var pop_progress: float = 0.0
@export var influence_range: int = 1
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
		"ref" = ref
	}
	
func deserialize(data: Dictionary) -> void:
	settlement_name = data["settlement_name"]
	pop = data["pop"]
	pop_progress = data["pop_progress"]
	influence_range = data["influence_range"]
	id = data["id"]	
	if data.has("owned_player_id"):
		if data["owned_player_id"] != -1:
			owned_player =  GameStateService.data_service.world_dict["player_data"]["players"][data["owned_player_id"]]
	
	data_updated.emit()
	
static func default_data() -> Dictionary:
	return {
		"id"= randi(),
		"settlement_name" = "New City",
		"pop" = 0,
		"pop_progress" = 0.0,
		"influence_range" = 1,
		"owned_player_id" = -1
	}
