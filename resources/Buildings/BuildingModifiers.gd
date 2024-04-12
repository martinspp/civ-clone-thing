extends Object

class_name BuildingModifiers

static var modifier_dict := {
	"food_modifier" = {"func": food_modifier},
	"unlock_building" = {"func" : unlock_building},
	"unlock_unit" = {"func" : unlock_unit},
}

static func food_modifier(settlement: Settlement, value: float) -> void:
	var settlement_data : SettlementData = settlement.settlement_data
	settlement_data.food += value

static func unlock_building(settlement: Settlement, value: String) -> void:
	var settlement_data : SettlementData = settlement.settlement_data
	settlement_data.available_buildings.append(ResourceRegistry.get_building_type_by_name(value))

static func unlock_unit(settlement: Settlement, value: String) -> void:
	var settlement_data : SettlementData = settlement.settlement_data
	settlement_data.available_units.append(ResourceRegistry.get_unit_type_by_name(value))