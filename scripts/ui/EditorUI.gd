extends Control

class_name EditorUI

var type_selected: HexType

@export var hextypes_itemlist: ItemList
@export var units_itemlist: ItemList
@export var other_itemlist: ItemList
@export var actions_itemlist: ItemList

@export var settlement_data: HBoxContainer

@export var seperator: HSeparator
@export var settlement_name: LineEdit
@export var settlement_pop: Label
@export var settlement_progress: Label
@export var settlement_influence: Label
@export var player_option: OptionButton

signal type_changed(type: String, sub_type: String)
signal map_save_load(action: String)
signal start_game()

func _ready() -> void:
	type_changed.connect(GameStateService.editor_service._on_editor_ui_type_changed)
	map_save_load.connect(GameStateService.data_service._on_editor_ui_map_save_load)
	start_game.connect(GameStateService.start_game)
	PlayEventBus.player_list_updated.connect(update_player_options)

	_populate_itemboxes()

func set_settlement_info(settlement: Settlement) -> void:
	update_player_options()
	settlement_data.set_meta("s_ref", settlement)
	settlement_data.set_visible(true)
	seperator.set_visible(true)
	settlement_name.text = settlement.settlement_data.settlement_name
	settlement_pop.text = str(settlement.settlement_data.pop)
	settlement_progress.text = str(settlement.settlement_data.pop_progress)
	settlement_influence.text = str(settlement.settlement_data.influence_range)
	if settlement.settlement_data.owned_player:
		player_option.selected = player_option.get_item_index(settlement.settlement_data.owned_player.id)
	else:
		player_option.selected = player_option.get_item_index(1)

func _on_option_button_item_selected(index: int) -> void:
	var settlement :Settlement = settlement_data.get_meta("s_ref")
	if player_option.get_item_id(index) == 1:
		settlement.settlement_data.owned_player = null	
	else:
		settlement.settlement_data.owned_player = GameStateService.data_service.get_player_by_id(player_option.get_item_id(index))
	settlement.update_data()
	GameStateService.data_service.update_settlement_data(settlement)

func _close_settlement_data() -> void:
	settlement_data.set_visible(false)
	seperator.set_visible(false)
	settlement_data.set_meta("s_ref",null)
	
func _populate_itemboxes() -> void:
	hextypes_itemlist.clear()
	for hextype in ResourceRegistry.hex_type_registry:
		hextypes_itemlist.add_item(hextype.data_name)
	
	units_itemlist.clear()
	for unit_data in ResourceRegistry.unit_type_registry:
		units_itemlist.add_item(unit_data.unit_name)

func unhighlight_lists():
	hextypes_itemlist.deselect_all()
	units_itemlist.deselect_all()
	other_itemlist.deselect_all()
	actions_itemlist.deselect_all()

func _on_hextypes_item_clicked(index:int, _at_position:Vector2, _mouse_button_index:int) -> void:
	unhighlight_lists()
	type_changed.emit("hex",ResourceRegistry.hex_type_registry[index].data_name)

func _on_actions_item_clicked(index:int, _at_position:Vector2, _mouse_button_index:int) -> void:
	unhighlight_lists()
	match index:
		0:
			type_changed.emit("action","select")
		1:
			map_save_load.emit("save")
		2:
			map_save_load.emit("load")
		3:	
			start_game.emit()
		_:
			print("unkown action")


func _on_other_item_clicked(index:int, _at_position:Vector2, _mouse_button_index:int) -> void:
	unhighlight_lists()
	match index:
		0:
			type_changed.emit("object","settlement")
		1:
			type_changed.emit("object","river")
		_:
			print("unkown other item")


func _on_units_item_clicked(index:int, _at_position:Vector2, _mouse_button_index:int) -> void:
	unhighlight_lists()
	type_changed.emit("unit",ResourceRegistry.unit_type_registry[index].unit_name)

func update_player_options() -> void:
	player_option.clear()
	player_option.add_item("Unset",1)
	for player in GameStateService.data_service.get_all_players():
		player_option.add_item(player.player_name, int(player.id))

func _on_s_name_text_submitted(text: String):
	var settlement :Settlement = settlement_data.get_meta("s_ref")
	settlement.settlement_data.settlement_name = text
	settlement.update_data()
	GameStateService.data_service.update_settlement_data(settlement)
