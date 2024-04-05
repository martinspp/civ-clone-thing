extends Control

class_name UnitUI

@export var thumbnail: TextureRect
@export var unit_name_label: Label
@export var health_label: Label
@export var action_points_label: Label
@export var damage_label: Label
@export var actions_grid : GridContainer


func _ready() -> void:
	PlayEventBus.unit_selected.connect(select)
	PlayEventBus.unit_unselected.connect(unselect)

func _set_ui_data(unit : Unit) -> void:
	thumbnail.texture = unit.unit_data.sprite
	unit_name_label.text = unit.unit_data.unit_name
	health_label.text = str(unit.unit_data.health)
	action_points_label.text = str(unit.unit_data.action_points)
	damage_label.text = str(unit.unit_data.attack_damage)

func _population_actions_grid(unit: Unit) -> void:
	for action: String in unit.unit_data.actions:
		var action_button : Button = Button.new()
		action_button.text = action.capitalize()
		actions_grid.add_child(action_button)
		action_button.pressed.connect(UnitActions.callable_dict[action]["func"])

func unselect() -> void:
	visible = false

func select(unit: Unit) -> void:
	if unit:
		_set_ui_data(unit)
		_population_actions_grid(unit)
		visible = true
	else:
		unselect()