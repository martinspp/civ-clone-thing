extends Node

signal update_gold(gold_amount: int)
signal update_turn(turn_number: int)

signal start_of_turn(new_turn_number: int)
signal end_of_turn()

signal player_end_turn(player: Player)

signal object_finished_end_turn_action(object: Variant)

#region clicking events
signal hex_clicked(clicked_hex: Hex, event: InputEvent)
signal hex_alt_clicked(clicked_hex: Hex, event: InputEvent)
signal settlement_clicked(settlement: Settlement, event: InputEvent)
#endregion

#region unit
signal unit_selected(unit: Unit)
signal unit_unselected()
#endregion

#region settlement
signal settlement_highlighted(settlement: Settlement)
signal settlement_unhighlighted()

signal settlement_selected(settlement: Settlement)
signal settlement_unselected(settlement: Settlement)
#endregion

#region player stuff 
signal current_player_changed(player: Player)
signal player_list_updated()
#endregion