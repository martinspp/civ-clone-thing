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
	PlayEventBus.settlement_unhighlighted.connect(func(): selected_object = null)

func hex_click_event(hex: Hex, event: InputEvent):
	# Check if hex has a settlement, if it does, check if we are over it.
	if hex.units.size() > 0:
		unit_clicked(hex.units[0], event)
		
	elif hex.settlement:
		settlement_clicked(hex.settlement, event)
		
	else:
		hex_clicked(hex, event)


func hex_clicked(hex: Hex, event: InputEvent):
	selected_object = hex

func unit_clicked(unit: Unit, event: InputEvent):
	selected_object = unit
	
func settlement_clicked(settlement: Settlement, event: InputEvent):
	if (event as InputEventMouseButton).double_click == true:
		selected_object = settlement
		PlayEventBus.settlement_highlighted.emit(settlement)
		settlement.select()
