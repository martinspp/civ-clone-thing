extends Area2D

class_name Settlement

@onready var selected_ui: Control = %SelectedUI
@onready var world_ui: Control = %WorldUI

@onready var settlement_data: SettlementData = SettlementData.new()
@onready var parent_hex: Hex = get_parent() as Hex

#region settlement_name_label
var settlement_name_label: String:
	get:
		return settlement_name_label
	set(value):
		%SettlementNameLabel.text = value
		%SettlementNameLabel_Copy.text = value		
		settlement_name_label = value
#endregion
#region settlement_growth_label
var settlement_growth_label: String:
	get:
		return settlement_growth_label
	set(value):
		%GrowthLabel.text = value
		%GrowthLabel_Copy.text = value
		settlement_growth_label = value
#endregion
#region settlement_pop_label
var settlement_pop_label: String:
	get:
		return settlement_pop_label
	set(value):
		%PopulationLabel.text = value
		%PopulationLabel_Copy.text = value
		settlement_pop_label = value
#endregion

var selected: bool:
	get:
		return selected
	set(value):
		selected_ui.visible = value
		world_ui.visible = !value

func _ready() -> void:
	settlement_name_label = settlement_data.settlement_name
	parent_hex.settlement = self
	selected_ui.visible = false
	settlement_data.connect("data_updated",update_ui_data)
	settlement_data.ref = self
	PlayEventBus.player_list_updated.connect(update_ui_data)
	PlayEventBus.current_player_changed.connect(update_ui_state)

func _exit_tree() -> void:
	parent_hex.settlement = null

func _on_exit_pressed() -> void:
	selected = false
	PlayEventBus.settlement_unhighlighted.emit()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed == true:
			if GameStateService.current_state == GameStateService.game_states.PLAY:
				PlayEventBus.settlement_clicked.emit(self,event)

func update_ui_data():
	settlement_name_label = settlement_data.settlement_name

	# Check if owned player still exists
	if !GameStateService.data_service.is_player_exist(settlement_data.owned_player):
		settlement_data.owned_player = null

	if settlement_data.owned_player:
		%SettlementNameLabel.modulate = settlement_data.owned_player.color
		%SettlementNameLabel_Copy.modulate = settlement_data.owned_player.color
	else:
		%SettlementNameLabel.modulate = Color.BLACK
		%SettlementNameLabel_Copy.modulate = Color.BLACK
	
	settlement_growth_label = str(0)
	settlement_pop_label = str(settlement_data.pop)

func update_ui_state():
	pass
