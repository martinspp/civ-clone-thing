extends Control

class_name SettlementUI

@export var buildings_list_container : VBoxContainer
@export var garrison_container: GridContainer
@export var settlement_name: Label

var _settlement: Settlement
	
func _init() -> void:
	pass

func _ready() -> void:
	PlayEventBus.settlement_selected.connect(_update_settlement)
	PlayEventBus.settlement_unselected.connect(_update_settlement.bindv([null]))
	PlayEventBus.start_of_turn.connect(_update_lists)

func _update_settlement(settlement: Settlement) -> void:
	if settlement:
		_settlement = settlement
		_populate_buildings_list()
		_populate_garrison()
		_update_settlement_label()
		visible = true
	else:
		_clear_lists()
		visible = false

func _update_lists(_foo: int) -> void:
	print("updating lists")
	if _settlement:
		_populate_buildings_list()
		_populate_garrison()
	else:
		_clear_lists()


func _clear_lists() -> void:
	for child in buildings_list_container.get_children():
		child.queue_free()
	for child in garrison_container.get_children():
		child.queue_free()

func _populate_buildings_list() -> void:
	for child in buildings_list_container.get_children():
		child.queue_free()
	for building: Building in _settlement.built_buildings:
		var new_label :Label = Label.new()
		new_label.text = building.building_data.building_name.capitalize()
		buildings_list_container.add_child(new_label)

func _populate_garrison() -> void:
	for child in garrison_container.get_children():
		child.queue_free()
	for unit: Unit in _settlement.garrisoned_units:
		var new_button :Button = Button.new()
		new_button.text = unit.unit_data.unit_name.capitalize()
		garrison_container.add_child(new_button)
		new_button.pressed.connect(func() -> void : PlayEventBus.unit_selected.emit(unit))
		
	
func _update_settlement_label() -> void:
	if _settlement:
		settlement_name.text = _settlement.settlement_data.settlement_name
		settlement_name.modulate = _settlement.settlement_data.owned_player.color
	else:
		settlement_name.text = ""