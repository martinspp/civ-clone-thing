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

static func unlock_building(settlement: Settlement, value: BuildingData) -> void:
	var settlement_data : SettlementData = settlement.settlement_data
	settlement_data.available_buildings.append(value)

static func unlock_unit(settlement: Settlement, value: UnitType) -> void:
	var settlement_data : SettlementData = settlement.settlement_data
	settlement_data.available_units.append(value)