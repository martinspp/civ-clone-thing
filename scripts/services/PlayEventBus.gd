extends Node

signal player_list_updated()


signal update_gold(gold_amount: int)
signal update_turn(turn_number :int)

signal end_turn()

signal hex_clicked(clicked_hex: Hex, event: InputEvent)
signal settlement_clicked(settlement: Settlement)

signal unit_selected(unit: Unit)

signal settlement_highlighted(settlement: Settlement)
signal settlement_unhighlighted()