extends Control

class_name SettlementUI

@export var buildings_list_container : VBoxContainer
@export var units_list_container : VBoxContainer
@export var settlement_name: Label


@export_category("Garisson panel")
@export var garrison_seperator: VSeparator
@export var garrison_section_container : BoxContainer
@export var garrison_container: GridContainer

@export_category("Progress panel")
@export var progress_panel: PanelContainer
@export var progress_bar: ProgressBar
@export var progress_label: Label

signal update_lists()

var _settlement: Settlement
	
func _init() -> void:
	pass

func _ready() -> void:
	PlayEventBus.settlement_selected.connect(_update_settlement)
	PlayEventBus.settlement_unselected.connect(_update_settlement.bindv([null]))
	PlayEventBus.start_of_turn.connect(_update_lists)
	update_lists.connect(_update_lists.bind(0))
	

func _update_settlement(settlement: Settlement) -> void:
	if settlement:
		_settlement = settlement
		_populate_buildings_list()
		_populate_units_list()
		_populate_garrison()
		_update_settlement_label()
		_update_progress_panel()
		visible = true
	else:
		_clear_lists()
		visible = false

func _update_lists(_foo: int) -> void:
	print("updating lists")
	if _settlement:
		_populate_buildings_list()
		_populate_units_list()
		_populate_garrison()
		_update_progress_panel()
	else:
		_clear_lists()


func _clear_lists() -> void:
	for child in buildings_list_container.get_children():
		child.queue_free()
	for child in units_list_container.get_children():
		child.queue_free()
	for child in garrison_container.get_children():
		child.queue_free()

func _update_progress_panel() -> void:
	if _settlement && _settlement.settlement_data.current_production != "":
		progress_panel.visible = true
		progress_label.text = _settlement.settlement_data.current_production.capitalize()
		progress_bar.value = _settlement.settlement_data.get_production_progress(_settlement.settlement_data.current_production)
	else:
		progress_panel.visible = false

func _populate_buildings_list() -> void:
	for child in buildings_list_container.get_children():
		child.queue_free()

	for building_type in _settlement.available_buildings:
		var new_button: Button = Button.new()
		new_button.text = building_type.capitalize()
		buildings_list_container.add_child(new_button)
		new_button.pressed.connect(_settlement.start_production.bind(building_type))

	for building: Building in _settlement.built_buildings:
		var new_label :Label = Label.new()
		new_label.text = building.building_data.building_name.capitalize()
		buildings_list_container.add_child(new_label)

func _populate_units_list() -> void:
	for child in units_list_container.get_children():
		child.queue_free()
	for unit_name in _settlement.available_units:
		var new_button: Button = Button.new()
		new_button.text = unit_name.capitalize()
		units_list_container.add_child(new_button)
		new_button.pressed.connect(_settlement.start_production.bind(unit_name))

func _populate_garrison() -> void:
	for child in garrison_container.get_children():
		child.queue_free()
	for unit: Unit in _settlement.garrisoned_units:
		var new_button :Button = Button.new()
		new_button.text = unit.unit_data.unit_name.capitalize()
		garrison_container.add_child(new_button)
		new_button.pressed.connect(func() -> void : PlayEventBus.unit_selected.emit(unit))
	if _settlement.garrisoned_units.size() == 0:
		garrison_seperator.visible = false
		garrison_section_container.visible = false
	else:
		garrison_seperator.visible = true
		garrison_section_container.visible = true
		
	
func _update_settlement_label() -> void:
	if _settlement:
		settlement_name.text = _settlement.settlement_data.settlement_name
		settlement_name.modulate = _settlement.settlement_data.owned_player.color
	else:
		settlement_name.text = ""