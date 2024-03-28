extends Node

signal update_gold(gold_amount: int)
signal update_turn(turn_number: int)

signal start_of_turn()
signal end_of_turn()

signal player_end_turn(player: Player)

signal hex_clicked(clicked_hex: Hex, event: InputEvent)
signal settlement_clicked(settlement: Settlement, event: InputEvent)

#region unit
signal unit_selected(unit: Unit)
signal unit_unselected()
#endregion

signal settlement_highlighted(settlement: Settlement)
signal settlement_unhighlighted()

#region player stuff 
signal current_player_changed(player: Player)
signal player_list_updated()
#endregion