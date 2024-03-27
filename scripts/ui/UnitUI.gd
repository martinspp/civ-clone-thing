extends Control

class_name UnitUI

@export var thumbnail: TextureRect
@export var unit_name_label: Label
@export var health_label: Label
@export var action_points_label: Label
@export var damage_label: Label
@export var actions_grid : GridContainer


func _ready() -> void:
	PlayEventBus.unit_unselected.connect(unselect)

func set_ui_data(unit : Unit) -> void:
	thumbnail.texture = unit.unit_data.sprite
	unit_name_label.text = unit.unit_data.unit_name
	health_label.text = str(unit.unit_data.health)
	action_points_label.text = str(unit.unit_data.action_points)
	damage_label.text = str(unit.unit_data.attack_damage)

func population_actions_grid(unit: Unit) -> void:
	for action in unit.unit_data.actions:
		var action_button : Button = Button.new()
		action_button.text = action
		actions_grid.add_child(action_button)
		action_button.connect("pressed", UnitActions.callable_dict[action])

func unselect():
	Unit.selected_unit = null
	visible = false