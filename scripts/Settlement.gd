extends Area2D

class_name Settlement

@onready var selected_ui: Control = %SelectedUI
@onready var world_ui: Control = %WorldUI




@onready var settlement_data: SettlementData = SettlementData.new()
@onready var parent_hex: Hex = get_parent() as Hex

#region settlement_name label
@onready var settlement_name_label: Label = %SettlementNameLabel
@onready var settlement_name_label_selected: Label = %SettlementNameLabel_Copy
var settlement_name_text: String:
	get:
		return settlement_name_text
	set(value):
		settlement_name_label.text = value
		settlement_name_label_selected.text = value		
		settlement_name_text = value
#endregion

var selected: bool:
	get:
		return selected
	set(value):
		selected_ui.visible = value
		world_ui.visible = !value

func _ready() -> void:
	settlement_name_label.text = settlement_data.settlement_name
	settlement_name_label_selected.text = settlement_data.settlement_name
	parent_hex.settlement = self
	selected_ui.visible = false
	settlement_data.connect("data_updated",update_data)
	settlement_data.ref = self
	PlayEventBus.player_list_updated.connect(update_data)
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

func update_data():
	settlement_name_text = settlement_data.settlement_name

	# Check if owned player still exists
	if !GameStateService.data_service.is_player_exist(settlement_data.owned_player):
		settlement_data.owned_player = null

	if settlement_data.owned_player:
		settlement_name_label.modulate = settlement_data.owned_player.color
		settlement_name_label_selected.modulate = settlement_data.owned_player.color
	else:
		settlement_name_label.modulate = Color.BLACK
		settlement_name_label_selected.modulate = Color.BLACK


func update_ui_state():
	pass
