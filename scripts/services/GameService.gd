extends Node

class_name GameService

var play_ui_scene: PackedScene = load("res://scenes/UI/Play/PlayUI.tscn")
var play_ui: PlayUI

func _ready() -> void:
	GameStateService.game_service = self
	play_ui = play_ui_scene.instantiate()
	$"../CanvasLayer".add_child(play_ui)
	PlayEventBus.hex_clicked.connect(hex_clicked)
	PlayEventBus.unit_clicked.connect(unit_clicked)
	PlayEventBus.settlement_clicked.connect(settlement_clicked)

func hex_clicked(hex: Hex, event: InputEvent):
	if hex.settlement:
		pass
	
func unit_clicked(unit: Unit, event: InputEvent):
	print(unit)
	
func settlement_clicked(settlement: Settlement, event: InputEvent):
	pass
