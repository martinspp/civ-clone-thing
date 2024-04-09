extends Area2D

class_name Settlement

@onready var world_ui: Control = %WorldUI

@onready var settlement_data: SettlementData = SettlementData.new()
@onready var parent_hex: Hex = get_parent() as Hex

#region settlement_name_label
var settlement_name_label: String:
	get:
		return %SettlementNameLabel.text
	set(value):
		%SettlementNameLabel.text = value		
#endregion

@onready var built_buildings: Array[Building] = []
@onready var garrisoned_units: Array[Unit] = []

#TODO move this somewhere else
static var starting_buildings : Array[String]= ["granary"]
static var starting_units :Array[String]= ["warrior"]


@onready var available_buildings: Array[String] = []
@onready var available_units: Array[String] = []

@export var unit_scene : PackedScene
# Used to flip the ui when settlement is focused
var selected: bool

func _ready() -> void:
	GameStateService.end_of_turn_actions[self] = false
	settlement_name_label = settlement_data.settlement_name
	parent_hex.settlement = self
	settlement_data.connect("data_updated",update_ui_data)
	settlement_data.ref = self
	PlayEventBus.player_list_updated.connect(update_ui_data)
	PlayEventBus.current_player_changed.connect(update_ui_state)
	PlayEventBus.start_of_turn.connect(_start_of_turn_actions)
	PlayEventBus.end_of_turn.connect(_end_of_turn_actions)
	%StopProduction.pressed.connect(stop_production)

	spawn_unit(ResourceRegistry.get_unit_type_by_name("warrior")).hex = parent_hex
	
	$Sprites.spawn_villagers(5)

	build_available_productions()

func _exit_tree() -> void:
	parent_hex.settlement = null

func _on_exit_pressed() -> void:
	selected = false
	PlayEventBus.settlement_unhighlighted.emit()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# does not handle the zoom in on double click, that is handled by double click on hex
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed == true:
			if GameStateService.current_state == GameStateService.game_states.PLAY:
				PlayEventBus.settlement_clicked.emit(self,event)

func update_ui_data() -> void:
	settlement_name_label = settlement_data.settlement_name

	# Check if owned player still exists
	if !GameStateService.data_service.is_player_exist(settlement_data.owned_player):
		settlement_data.owned_player = null

	if settlement_data.owned_player:
		%SettlementNameLabel.modulate = settlement_data.owned_player.color
	else:
		%SettlementNameLabel.modulate = Color.BLACK
	
	%GrowthLabel.text = str(0)
	%PopulationLabel.text = str(settlement_data.pop)

	if settlement_data.current_production != "":
		%ProductionContainer.visible = true
		%ProductionName.text = settlement_data.current_production.capitalize()
		%ProductionBar.value = settlement_data.get_production_progress(settlement_data.current_production)
	else:
		%ProductionContainer.visible = false


func update_ui_state() -> void:
	pass

func _start_of_turn_actions(_turn: int) -> void:
	build_available_productions()

func _end_of_turn_actions() -> void:
	# Finish production
	if settlement_data.current_production != "":
		if settlement_data.update_production_progress(settlement_data.current_production, 0.5) >= 1.0:
			var produced : Variant = ResourceRegistry.get_building_or_unit_by_name(settlement_data.current_production)
			if produced is UnitType:
				spawn_unit(produced).hex = parent_hex
			elif produced is BuildingData:
				add_building(produced)
			else:
				print("produced non existant type")
			settlement_data.current_production = ""
	%ProductionBar.value = settlement_data.get_production_progress(settlement_data.current_production)
	PlayEventBus.object_finished_end_turn_action.emit(self)
	update_ui_data()
	
func add_building(building_data: BuildingData) -> Building:
	print("built building " + building_data.building_name)
	var new_building :Building = Building.new()
	new_building.building_data = building_data
	add_child(new_building)
	built_buildings.append(new_building)
	return new_building

func remove_building(building: Building) -> void:
	building.queue_free()
	built_buildings.erase(building)

func spawn_unit(unit_data: UnitType) -> Unit:
	var new_unit :Unit = unit_scene.instantiate()
	GameStateService.world_manager.units.add_child(new_unit)
	new_unit.global_position.x = global_position.x
	new_unit.global_position.y = global_position.y
	new_unit.unit_data = unit_data
	new_unit.garrison(self)
	GameStateService.end_of_turn_actions[new_unit] = true
	print("new unit appended")
	return new_unit


func start_production(production_name: String) -> void:
	production_name = production_name.to_lower()
	settlement_data.update_production_progress(production_name, 0.0)
	settlement_data.current_production = production_name
	update_ui_data()
	GameStateService.game_service.settlement_ui.update_lists.emit()

func stop_production() -> void:
	settlement_data.current_production = ""
	update_ui_data()
	GameStateService.game_service.settlement_ui.update_lists.emit()


func build_available_productions() -> void:
	#TODO Check researches
	#TODO Check buildings
	#TODO remove built/obsolete buildings
	# Add starting things
	
	available_buildings = starting_buildings.duplicate(true)
	available_units = starting_units.duplicate(true)

	for b: Building in built_buildings:
		available_buildings.erase(b.building_data.building_name.to_lower())
