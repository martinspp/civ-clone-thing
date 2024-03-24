extends Node

class_name UnitActions

static var callable_dict = {
	"attack_unit_melee" = {"func": attack_unit_melee, "targeted": true},
	"move" = {"func":move, "targeted": true}

}	
static func attack_unit_melee(unit_from: Unit, target: Variant) -> ActionMessage:
	if target is Unit:
		target.unit_data.health -= unit_from.unit_data.attack_damage
		return ActionMessage.new(true, "")
	else:
		return ActionMessage.new(false, "Target isn't a unit")
	
static func move(unit_from: Unit, target: Variant) -> ActionMessage:
	return ActionMessage.new(false, "Not implemented")
