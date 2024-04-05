extends Area2D

class_name Settlement

@onready var selected_ui: Control = %SelectedUI
@onready var world_ui: Control = %WorldUI

@onready var settlement_data: SettlementData = SettlementData.new()
@onready var parent_hex: Hex = get_parent() as Hex

#region settlement_name_label
var settlement_name_label: String:
	get:
		return settlement_name_label
	set(value):
		%SettlementNameLabel.text = value
		%SettlementNameLabel_Copy.text = value		
		settlement_name_label = value
#endregion
#region settlement_growth_label
var settlement_growth_label: String:
	get:
		return settlement_growth_label
	set(value):
		%GrowthLabel.text = value
		%GrowthLabel_Copy.text = value
		settlement_growth_label = value
#endregion
#region settlement_pop_label
var settlement_pop_label: String:
	get:
		return settlement_pop_label
	set(value):
		%PopulationLabel.text = value
		%PopulationLabel_Copy.text = value
		settlement_pop_label = value
#endregion

@onready var built_buildings: Array[Building] = []
@onready var garrisoned_units: Array[Unit] = []

@onready var available_buildings: Array[BuildingData] = []
@onready var available_units: Array[UnitType] = []

@export var unit_scene : PackedScene
# Used to flip the ui when settlement is focused
var selected: bool:
	get:
		return selected
	set(value):
		selected_ui.visible = value
		world_ui.visible = !value

func _ready() -> void:
	GameStateService.end_of_turn_actions[self] = false
	settlement_name_label = settlement_data.settlement_name
	parent_hex.settlement = self
	selected_ui.visible = false
	settlement_data.connect("data_updated",update_ui_data)
	settlement_data.ref = self
	PlayEventBus.player_list_updated.connect(update_ui_data)
	PlayEventBus.current_player_changed.connect(update_ui_state)
	PlayEventBus.start_of_turn.connect(_start_of_turn_actions)
	PlayEventBus.end_of_turn.connect(_end_of_turn_actions)
	%StopProduction.pressed.connect(stop_production)
	spawn_unit(ResourceRegistry.get_unit_type_by_name("warrior"))

func _exit_tree() -> void:
	parent_hex.settlement = null

func _on_exit_pressed() -> void:
	selected = false
	PlayEventBus.settlement_unhighlighted.emit()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# does not handle the zoom in on double click, that is handled by double click on hex
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed == true:
			if GameStateService.current_state == GameStateService.game_states.PLAY:
				PlayEventBus.settlement_clicked.emit(self,event)

func update_ui_data() -> void:
	settlement_name_label = settlement_data.settlement_name

	# Check if owned player still exists
	if !GameStateService.data_service.is_player_exist(settlement_data.owned_player):
		settlement_data.owned_player = null

	if settlement_data.owned_player:
		%SettlementNameLabel.modulate = settlement_data.owned_player.color
		%SettlementNameLabel_Copy.modulate = settlement_data.owned_player.color
	else:
		%SettlementNameLabel.modulate = Color.BLACK
		%SettlementNameLabel_Copy.modulate = Color.BLACK
	
	settlement_growth_label = str(0)
	settlement_pop_label = str(settlement_data.pop)

	if settlement_data.current_production != "":
		%ProductionContainer.visible = true
		%ProductionName.text = settlement_data.current_production.capitalize()
		%ProductionBar.value = settlement_data.get_production_progress(settlement_data.current_production)
	else:
		%ProductionContainer.visible = false


func update_ui_state() -> void:
	pass

func _start_of_turn_actions(_turn: int) -> void:
	build_available_lists()

func _end_of_turn_actions() -> void:
	# Finish production
	if settlement_data.current_production != "":
		if settlement_data.update_production_progress(settlement_data.current_production, 0.5) >= 1.0:
			var produced : Variant = ResourceRegistry.get_building_or_unit_by_name(settlement_data.current_production)
			if produced is UnitType:
				spawn_unit(produced)
			elif produced is BuildingData:
				add_building(produced)
			else:
				print("produced non existant type")
			settlement_data.current_production = ""
	%ProductionBar.value = settlement_data.get_production_progress(settlement_data.current_production)
	PlayEventBus.object_finished_end_turn_action.emit(self)
	update_ui_data()
	
func add_building(building_data: BuildingData) -> void:
	print("built building " + building_data.building_name)
	var new_building :Building = Building.new()
	new_building.building_data = building_data
	add_child(new_building)
	built_buildings.append(new_building)

func remove_building(building: Building) -> void:
	building.queue_free()
	built_buildings.erase(building)

func spawn_unit(unit_data: UnitType) -> void:
	var new_unit :Unit = unit_scene.instantiate()
	GameStateService.world_manager.units.add_child(new_unit)
	new_unit.global_position.x = global_position.x
	new_unit.global_position.y = global_position.y
	new_unit.unit_data = unit_data
	garrisoned_units.append(new_unit)
	new_unit.garrison(self)
	GameStateService.end_of_turn_actions[new_unit] = true
	print("new unit appended")

#TODO move this somewhere else
static var starting_buildings := ["granary"]
static var starting_units := ["warrior"]

func start_production(building_name: String) -> void:
	settlement_data.update_production_progress(building_name, 0.0)
	settlement_data.current_production = building_name
	update_ui_data()

func stop_production() -> void:
	settlement_data.current_production = ""
	update_ui_data()


func build_available_lists() -> void:
	#TODO Check researches
	#TODO Check buildings
	#TODO remove built/obsolete buildings
	# Add starting things

	#clearing current lists
	for n: Node in %Units.get_children() + %Buildings.get_children():
		if n is Label:
			continue
		else:
			n.queue_free()
	
	var building_list := starting_buildings.duplicate(true)
	var unit_list := starting_units.duplicate(true)

	for b: Building in built_buildings:
		building_list.erase(b.building_data.building_name.to_lower())

	for b: String in building_list:
		var new_button: Button = Button.new()
		new_button.text = b.capitalize()
		%Buildings.add_child(new_button)
		new_button.pressed.connect(start_production.bind(b))


	for u: String in unit_list:
		var new_button: Button = Button.new()
		new_button.text = u.capitalize()
		%Units.add_child(new_button)
		new_button.pressed.connect(start_production.bind(u))