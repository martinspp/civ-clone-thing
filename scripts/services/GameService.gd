extends Node

class_name GameService

var play_ui_scene: PackedScene = load("res://scenes/UI/Play/PlayUI.tscn")
var play_ui: PlayUI

static var selected_object: Variant

var turn_counter: int = 1

func _ready() -> void:
	set_name("GameService")
	GameStateService.game_service = self
	play_ui = play_ui_scene.instantiate()
	$"../CanvasLayer".add_child(play_ui)
	PlayEventBus.hex_clicked.connect(hex_click_event)
	PlayEventBus.settlement_unhighlighted.connect(unselect_settlement)
	PlayEventBus.object_finished_end_turn_action.connect(_object_finished_actions)
	

func hex_click_event(hex: Hex, event: InputEvent) -> void:
	if hex.units.size() > 0:
		unit_clicked(hex.units[0], event)
		
	elif hex.settlement:
		settlement_clicked(hex.settlement, event)
		
	else:
		hex_clicked(hex, event)


func hex_clicked(hex: Hex, _event: InputEvent) -> void:
	if selected_object is Settlement:
		return
	else:
		selected_object = hex

func unit_clicked(unit: Unit, _event: InputEvent) -> void:
	selected_object = unit

func settlement_clicked(settlement: Settlement, event: InputEvent) -> void:
	if (event as InputEventMouseButton).double_click == true && settlement.settlement_data.owned_player == GameStateService.current_player:
		# Something else is already selected, should defocus
		if selected_object != null && (selected_object != settlement) && selected_object is Settlement:
			unselect_settlement()
			select_settlement(settlement)
		elif selected_object == settlement:
			return
		else:
			select_settlement(settlement)

func select_settlement(settlement: Settlement) -> void:
	selected_object = settlement
	PlayEventBus.settlement_highlighted.emit(settlement)
	settlement.selected = true

func unselect_settlement() -> void:
	if selected_object is Settlement:
		selected_object.selected = false
		selected_object = null

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

