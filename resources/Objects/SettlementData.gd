extends Resource

class_name SettlementData

@export var settlement_name: String = "New City"
@export var pop: int = 0
@export var pop_progress: float = 0.0
@export var influence_range: int = 1

func _init() -> void:
	pass

func serialize() -> Dictionary:
	return {
		"settlement_name" = settlement_name,
		"pop" = pop,
		"pop_progress" = pop_progress,
		"influence_range" = influence_range
	}
	
func deserialize(data: Dictionary) -> void:
	settlement_name = data["settlement_name"]
	pop = data["pop"]
	pop_progress = data["pop_progress"]
	influence_range = data["influence_range"]
	
static func default_data() -> Dictionary:
	return {
		"settlement_name" = "New City",
		"pop" = 0,
		"pop_progress" = 0.0,
		"influence_range" = 1
	}
