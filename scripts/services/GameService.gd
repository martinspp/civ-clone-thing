extends Node

class_name GameService

var play_ui_scene: PackedScene = load("res://scenes/UI/Play/PlayUI.tscn")
var play_ui: PlayUI

var settlement_ui_scene: PackedScene = load("res://scenes/UI/Play/SettlementUI.tscn")
var settlement_ui: SettlementUI

var unit_ui_scene: PackedScene = load("res://scenes/UI/Play/UnitUI.tscn")
var unit_ui: UnitUI

var select_target_ui_scene: PackedScene = load("res://scenes/UI/Play/UnitActionSelectionUI.tscn")
var select_target_ui: UnitActionSelectionUI

static var selected_object: Variant

# Used for the settlement bottom right ui
static var selected_ui_settlement: Settlement

#region target selection
static var targeted_object: Variant
static var selecting_target: bool = false
signal target_set()
#endregion

var turn_counter: int = 1

func _ready() -> void:
	set_name("GameService")
	GameStateService.game_service = self

	play_ui = play_ui_scene.instantiate()
	$"../CanvasLayer".add_child(play_ui)

	settlement_ui = settlement_ui_scene.instantiate()
	$"../CanvasLayer".add_child(settlement_ui)
	settlement_ui._update_settlement(null)

	unit_ui = unit_ui_scene.instantiate()
	$"../CanvasLayer".add_child(unit_ui)
	unit_ui.unselect()

	PlayEventBus.hex_clicked.connect(hex_click_event)
	PlayEventBus.hex_alt_clicked.connect(hex_alt_clicked)
	PlayEventBus.settlement_unhighlighted.connect(unfocus_settlement)
	PlayEventBus.object_finished_end_turn_action.connect(_object_finished_actions)
	PlayEventBus.start_of_turn.connect(_start_of_turn_actions)
	

func hex_click_event(hex: Hex, event: InputEvent) -> void:
		
	if hex.settlement:
		settlement_clicked(hex.settlement, event)
	elif hex.units.size() > 0:
		unit_clicked(hex.units[0], event)	
	else:
		hex_clicked(hex, event)

#region hex clicked event
func hex_clicked(hex: Hex, _event: InputEvent) -> void:
	if selecting_target:
		handle_targeting(hex, _event)
		return
	unselect_settlement()

	PlayEventBus.unit_unselected.emit()
	if selected_object is Settlement:
		return
	else:
		selected_object = hex

func hex_alt_clicked(hex: Hex, _event: InputEvent) -> void:
	if selecting_target:
		handle_targeting(null, _event)
#endregion

func unit_clicked(unit: Unit, _event: InputEvent) -> void:
	PlayEventBus.unit_selected.emit(unit)


func settlement_clicked(settlement: Settlement, event: InputEvent) -> void:
	if selecting_target:
		handle_targeting(settlement, event)
		return
	print(settlement.settlement_data.owned_player)
	print(GameStateService.current_player)
	if (event as InputEventMouseButton).double_click == false && settlement.settlement_data.owned_player == GameStateService.current_player:
		if selected_ui_settlement:
			unselect_settlement()
		select_settlement(settlement)
	

	if (event as InputEventMouseButton).double_click == true && settlement.settlement_data.owned_player == GameStateService.current_player:
		return
		# Something else is already selected, should defocus
		#if selected_object != null && (selected_object != settlement) && selected_object is Settlement:
		#	unfocus_settlement()
		#	focus_settlement(settlement)
		#elif selected_object == settlement:
		#	return
		#else:
		#	focus_settlement(settlement)

func handle_targeting(target: Variant, _vent: InputEvent) -> void:
	targeted_object = target
	selecting_target = false
	target_set.emit()

#region focusing
func focus_settlement(settlement: Settlement) -> void:
	selected_object = settlement
	PlayEventBus.settlement_highlighted.emit(settlement)
	settlement.selected = true

func unfocus_settlement() -> void:
	if selected_object is Settlement:
		selected_object.selected = false
		selected_object = null
		unselect_settlement()
#endregion

#region selecting
func select_settlement(settlement: Settlement) -> void:
	selected_ui_settlement = settlement
	PlayEventBus.settlement_selected.emit(settlement)
	

func unselect_settlement() -> void:
	selected_ui_settlement = null
	PlayEventBus.settlement_unselected.emit()

#endregion 

func check_for_next_turn() -> void:
	var all_players_finished := true
	for player: Player in GameStateService.data_service.get_all_players():
		if !player.ended_turn:
			all_players_finished = false

	if all_players_finished:
		PlayEventBus.end_of_turn.emit()
		for player: Player in GameStateService.data_service.get_all_players():
			player.ended_turn = false

func _object_finished_actions(object: Variant) -> void:
	GameStateService.end_of_turn_actions[object] = true
	for object_state: bool in GameStateService.end_of_turn_actions.values():
		if !object_state:
			return
	print("all objects finished end of turn actions")
	turn_counter += 1
	PlayEventBus.start_of_turn.emit(turn_counter)

	for obj: Variant in GameStateService.end_of_turn_actions:
		GameStateService.end_of_turn_actions[obj] = false

func get_target() -> Variant:
	await target_set
	return targeted_object
func _start_of_turn_actions(turn: int) -> void:
	FowRevealer.reveal_revealed_hexes()