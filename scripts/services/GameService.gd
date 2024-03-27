extends Node

class_name GameService

var play_ui_scene: PackedScene = load("res://scenes/UI/Play/PlayUI.tscn")
var play_ui: PlayUI

var selected_object: Variant

func _ready() -> void:
	GameStateService.game_service = self
	play_ui = play_ui_scene.instantiate()
	$"../CanvasLayer".add_child(play_ui)
	PlayEventBus.hex_clicked.connect(hex_click_event)
	PlayEventBus.settlement_unhighlighted.connect(unselect_settlement)
	

func hex_click_event(hex: Hex, event: InputEvent):
	if hex.units.size() > 0:
		unit_clicked(hex.units[0], event)
		
	elif hex.settlement:
		settlement_clicked(hex.settlement, event)
		
	else:
		hex_clicked(hex, event)


func hex_clicked(hex: Hex, _event: InputEvent):
	if selected_object is Settlement:
		return
	else:
		selected_object = hex

func unit_clicked(unit: Unit, _event: InputEvent):
	selected_object = unit

func settlement_clicked(settlement: Settlement, event: InputEvent):
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