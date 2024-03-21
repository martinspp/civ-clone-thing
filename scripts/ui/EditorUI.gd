extends Control

class_name EditorUI

var type_selected: HexType

@export var hextypes_itemlist: ItemList
@export var units_itemlist: ItemList
@export var other_itemlist: ItemList
@export var actions_itemlist: ItemList

@export var settlement_data: HBoxContainer

@export var seperator: HSeparator
@export var settlement_name: Label
@export var settlement_pop: Label
@export var settlement_progress: Label
@export var settlement_influence: Label

signal type_changed(String)
signal map_save_load(String)
signal start_game()

func _ready() -> void:
	type_changed.connect(GameStateService.editor_service._on_editor_ui_type_changed)
	map_save_load.connect(GameStateService.data_service._on_editor_ui_map_save_load)
	start_game.connect(GameStateService.start_game)
	_populate_itemboxes()

func set_settlement_info(settlement: Settlement) -> void:
	settlement_data.set_visible(true)
	seperator.set_visible(true)
	settlement_name.text = settlement.settlement_data.settlement_name
	settlement_pop.text = str(settlement.settlement_data.pop)
	settlement_progress.text = str(settlement.settlement_data.pop_progress)
	settlement_influence.text = str(settlement.settlement_data.influence_range)

func _close_settlement_data() -> void:
	settlement_data.set_visible(false)
	seperator.set_visible(false)
	
func _populate_itemboxes() -> void:
	hextypes_itemlist.clear()
	for hextype in ResourceRegistry.hex_type_registry:
		hextypes_itemlist.add_item(hextype.data_name)
	
	units_itemlist.clear()
	for unit_data in ResourceRegistry.unit_data_registry:
		units_itemlist.add_item(unit_data.unit_name)

func unhighlight_lists():
	hextypes_itemlist.deselect_all()
	units_itemlist.deselect_all()
	other_itemlist.deselect_all()
	actions_itemlist.deselect_all()

func _on_hextypes_item_clicked(index:int, _at_position:Vector2, _mouse_button_index:int) -> void:
	unhighlight_lists()
	type_changed.emit(ResourceRegistry.hex_type_registry[index].data_name)

func _on_actions_item_clicked(index:int, _at_position:Vector2, _mouse_button_index:int) -> void:
	unhighlight_lists()
	match index:
		0:
			type_changed.emit("select")
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
			type_changed.emit("settlement")
		1:
			type_changed.emit("river")
		_:
			print("unkown other item")


func _on_units_item_clicked(_index:int, _at_position:Vector2, _mouse_button_index:int) -> void:
	unhighlight_lists()
	print("not implemented")

