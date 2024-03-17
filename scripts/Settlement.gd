extends Area2D

class_name Settlement

@onready var selected_ui: Control = %SelectedUI
@onready var world_ui: Control = %WorldUI

@onready var settlement_name_label: Label = %SettlementNameLabel
@onready var settlement_name_label_selected: Label = %SettlementNameLabel_Copy

@onready var settlement_data: SettlementData = SettlementData.new()
@onready var parent_hex: Hex = get_parent() as Hex

func _ready() -> void:
	settlement_name_label.text = settlement_data.settlement_name
	settlement_name_label_selected.text = settlement_data.settlement_name
	parent_hex.settlement = self
	selected_ui.visible = false

func _exit_tree() -> void:
	parent_hex.settlement = null

func _on_exit_pressed() -> void:
	unselect()
	PlayEventBus.settlement_unhighlighted.emit()

func select() -> void:
	selected_ui.visible = true
	world_ui.visible = false

func unselect() -> void:
	selected_ui.visible = false
	world_ui.visible = true

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed == true:
			if GameStateService.current_state == GameStateService.game_states.PLAY:
				PlayEventBus.settlement_clicked.emit(self,event)

