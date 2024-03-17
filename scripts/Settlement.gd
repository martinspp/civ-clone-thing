extends Area2D

class_name Settlement

@onready var label: Label = $Label

@onready var settlement_data: SettlementData = SettlementData.new()
@onready var parent_hex: Hex = get_parent() as Hex

func _ready() -> void:
	label.text = settlement_data.settlement_name
	parent_hex.settlement = self
	#parent_hex.collision.disabled = true

func _exit_tree() -> void:
	parent_hex.settlement = null

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed == true:
			if GameStateService.current_state == GameStateService.game_states.PLAY:
				PlayEventBus.emit_signal("settlement_clicked",self,event)
