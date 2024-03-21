extends Node

signal player_list_updated()


signal update_gold(int)
signal update_turn(int)

signal end_turn()

signal hex_clicked(Hex, InputEvent)
signal settlement_clicked(Settlement)
signal unit_clicked(Unit)


signal settlement_highlighted(Settlement)
signal settlement_unhighlighted()