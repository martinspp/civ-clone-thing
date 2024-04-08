extends Container

class_name PlayUI

@export var round_value_label: Label
@export var gold_value_label: Label

@export var end_turn_button: Button


func _ready() -> void:
	PlayEventBus.update_gold.connect(_update_gold)
	PlayEventBus.update_turn.connect( _update_round)
	end_turn_button.pressed.connect( _end_turn_button)

	PlayEventBus.settlement_highlighted.connect(_highlight_settlement)
	PlayEventBus.settlement_unhighlighted.connect(_unhighlight_settlement)

	PlayEventBus.start_of_turn.connect(_update_turn_counter)


func _update_gold(amnt: int) -> void:
	gold_value_label.text = str(amnt)

func _update_round(amnt: int) -> void:
	round_value_label.text = str(amnt)

func _end_turn_button() -> void:
	PlayEventBus.player_end_turn.emit(GameStateService.current_player)


func _highlight_settlement(settlement: Settlement) -> void:
	#GameStateService.camera.focus_settlement(settlement.global_position,Vector2(2,2))
	pass

func _unhighlight_settlement() -> void:
	#GameStateService.camera.unfocus_settlement()
	pass

func _update_turn_counter(new_turn_number: int) -> void:
	round_value_label.text = str(new_turn_number)