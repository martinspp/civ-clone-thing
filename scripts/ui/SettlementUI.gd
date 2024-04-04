extends Control

@onready var buildings_list_container : VBoxContainer= %BuildingsListContainer
@onready var garrison_container: GridContainer = %GridContainer

var settlement: Settlement:
	get:
		return settlement
	set(value):
		settlement = value
		_populate_buildings_list()
		_populate_garrison()
	
func _init() -> void:
	pass

func _ready() -> void:
	pass

func _update_lists() -> void:
	_populate_buildings_list()
	_populate_garrison()

func _populate_buildings_list() -> void:
	for child in buildings_list_container.get_children():
		child.queue_free()
	for building: Building in settlement.built_buildings:
		var new_label :Label = Label.new()
		new_label.text = building.building_data.building_name.capitalize()
		buildings_list_container.add_child(new_label)

func _populate_garrison() -> void:
	for child in garrison_container.get_children():
		child.queue_free()
	for unit: Unit in settlement.garissoned_units:
		var new_button :Button = Button.new()
		new_button.text = unit.unit_data.unit_name.capitalize()
		garrison_container.add_child(new_button)
		#TODO connect to the global signal to select the garrisoned unit
	