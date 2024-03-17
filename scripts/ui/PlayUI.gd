extends Container

class_name PlayUI

@export var round_value_label: Label
@export var gold_value_label: Label

@export var end_turn_button: Button


func _ready() -> void:
	PlayEventBus.connect("update_gold", _update_gold)
	PlayEventBus.connect("update_turn", _update_round)
	end_turn_button.connect("pressed", _end_turn_button)

func _update_gold(amnt: int) -> void:
	gold_value_label.text = str(amnt)

func _update_round(amnt: int) -> void:
	round_value_label.text = str(amnt)

func _end_turn_button() -> void:
	PlayEventBus.end_turn.emit()


