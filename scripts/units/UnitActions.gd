extends Node

class_name UnitActions

static var callable_dict := {
	"attack_unit_melee" = {"func": attack_unit_melee, "targeted": true},
	"move" = {"func":move, "targeted": true}
}

static func attack_unit_melee(unit_from: Unit) -> ActionMessage:
	var target: Variant = await UnitUI.get_move_target(unit_from)
	if target is Unit:
		target.unit_data.health -= unit_from.unit_data.attack_damage
		return ActionMessage.new(true, "")
	else:
		return ActionMessage.new(false, "Target isn't a unit")
	
static func move(unit_from: Unit) -> ActionMessage:
	print("waiting for continue_action %s " % unit_from.global_position)
	var target: Variant = await UnitUI.get_move_target(unit_from)
	print("continue action emitted %s " % target.global_position)
	return ActionMessage.new(false, "Not implemented")



