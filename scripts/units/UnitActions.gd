extends Node

class_name UnitActions

static var callable_dict := {
	"attack_unit_melee" = {"func": attack_unit_melee, "targeted": true},
	"move" = {"func":move, "targeted": true}
}

static func attack_unit_melee(unit_from: Unit) -> ActionMessage:
	var target: Variant = await UnitUI.get_target(unit_from, "melee")
	if target is Unit:
		target.unit_data.health -= unit_from.unit_data.attack_damage
		return ActionMessage.new(true, "")
	else:
		return ActionMessage.new(false, "Target isn't a unit")
	
static func move(unit_from: Unit) -> ActionMessage:
	var target: Variant = await UnitUI.get_target(unit_from, "path")
	if target is Settlement:
		unit_from.movement_target_hex = target.parent_hex	
	elif target is Hex:
		unit_from.movement_target_hex = target
	unit_from.perform_move()
	return ActionMessage.new(false, "Not implemented")



