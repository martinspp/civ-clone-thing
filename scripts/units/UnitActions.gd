extends Node

class_name UnitActions

static var callable_dict := {
	"attack_unit_melee" = {"func": attack_unit_melee, "targeted": true},
	"move" = {"func":move, "targeted": true},
	"settle" = {"func":settle, "targeted": true},
	"improve_hex" = {"func":improve_hex, "targeted": true}
}

static func attack_unit_melee(unit_from: Unit) -> ActionMessage:
	var target: Variant = await UnitUI.get_target(unit_from, "melee")
	if target is Unit:
		target.unit_data.health -= unit_from.unit_data.attack_damage
		return ActionMessage.new(true, "")
	else:
		return ActionMessage.new(false, "Target isn't a unit")
	
static func move(unit_from: Unit) -> ActionMessage:
	if is_instance_valid(unit_from):
		var target: Variant = await UnitUI.get_target(unit_from, "path")
		if is_instance_valid(unit_from):
			if target is Settlement:
				unit_from.movement_target_hex = target.parent_hex	
			elif target is Hex:
				unit_from.movement_target_hex = target
			unit_from.perform_move()
			return ActionMessage.new(true, "Move performed")
		else:
			return ActionMessage.new(false, "Unit no longer exists")
	else:
		return ActionMessage.new(false, "Unit no longer exists")

static func settle(unit_from: Unit) -> ActionMessage:
	if unit_from.parent_hex.settlement:
		return ActionMessage.new(false, "Cant settle on settled land")
	
	if !unit_from.parent_hex.hex_type.settleable:
		return ActionMessage.new(false, "Cant settle on this hex type")

	var settlement: Settlement = GameStateService.data_service.add_settlement(unit_from.parent_hex, null)
	
	if settlement:
		settlement.settlement_data.owned_player = unit_from.player
		settlement.settlement_data.settlement_name = "aaa"
		#Settlement created, remove self
		unit_from.queue_free()
		PlayEventBus.unit_unselected.emit()
		return ActionMessage.new(true, "Settlement created")
	else:
		return ActionMessage.new(false, "Couldn't create settlement")
	

static func improve_hex(unit_from: Unit) -> ActionMessage:
	return ActionMessage.new(false, "Not implemented")



