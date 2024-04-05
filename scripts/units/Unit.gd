extends Node2D
class_name Unit

# should only be set once when Unit.gd is initialized
var unit_data: UnitType:
	get:
		return unit_data
	set(value):
		sprite_2d.texture = value.sprite
		unit_data = value
		#if unit_data == null:
		#	unit_data = value.new()
		#else:
		#	unit_data = value


@export var sprite_2d: Sprite2D

var player: Player
var hex: Hex
var movement_target_hex: Hex

var garrisoned_settlement: Settlement

signal continue_action()

func _ready() -> void:
	GameStateService.end_of_turn_actions[self] = false
	PlayEventBus.start_of_turn.connect(_start_of_turn_actions)
	PlayEventBus.end_of_turn.connect(_end_of_turn_actions)

func perform_action(action: String,target: Variant) -> void:
	if UnitActions.callable_dict[action]["targeted"] && (target == null):
		print("no target given")
	var action_message: ActionMessage = Callable(UnitActions,action).callv([self, target])
	if action_message.success == false:
		print(action_message.message)

func serialize() -> Dictionary:
	var dict := {}
	dict["unit_type"] = unit_data.unit_name
	dict["health"] = unit_data.health
	dict["owner_id"] = player.id
	dict["action_points"] = unit_data.action_points
	return dict

func deserialize(data: Dictionary) -> void:
	#TODO proper deserialization from json for Unit
	unit_data = ResourceRegistry.get_unit_type_by_name(data["unit_type"]).new()
	player = GameStateService.data_service.get_player_by_id(data["onwer_id"])

func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		GameStateService.game_service.selected_object = self
		PlayEventBus.unit_selected.emit(Unit)

func _start_of_turn_actions(turn_number: int) -> void:
	pass

func _end_of_turn_actions() -> void:
	#TODO continue set walk action if AP points allow it
	PlayEventBus.object_finished_end_turn_action.emit(self)

func garrison(settlement: Settlement) -> void:
	if garrisoned_settlement:
		print("already garrisoned")
		return
	garrisoned_settlement = settlement
	visible = false

func ungarrsion() -> void:
	if garrisoned_settlement:
		garrisoned_settlement = null
		visible = true
	else:
		print("not garrisoned")