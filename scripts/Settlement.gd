extends Area2D

class_name Settlement

@onready var world_ui: Control = %WorldUI

@onready var settlement_data: SettlementData = SettlementData.new()
@onready var parent_hex: Hex = get_parent() as Hex
var influenced_hexes: Array[Hex]:
	get:
		return influenced_hexes
	set(value):
		influenced_hexes = value
		hex_highlighter.update_hexes(value)


#region settlement_name_label
var settlement_name_label: String:
	get:
		return %SettlementNameLabel.text
	set(value):
		%SettlementNameLabel.text = value		
#endregion

@onready var built_buildings: Array[Building] = []
@onready var garrisoned_units: Array[Unit] = []

@export var unit_scene : PackedScene
@export var hex_highlighter: HexHighlighter
# Used to flip the ui when settlement is focused, probably can be removed
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
	calculate_building_unlocks()
	
	influenced_hexes = GameStateService.data_service._axial_to_hex_array(Axial.spiral(parent_hex.axial, 1))


	#test stuff remove later
	spawn_unit(ResourceRegistry.get_unit_type_by_name("warrior")).parent_hex = parent_hex	
	$SettlementDecor.spawn_villagers(5)


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
	hex_highlighter.higlight_color = Color(settlement_data.owned_player.color, 0.2)
	influenced_hexes = GameStateService.data_service._axial_to_hex_array(Axial.spiral(parent_hex.axial, 1))

func update_ui_state() -> void:
	pass

func _start_of_turn_actions(_turn: int) -> void:
	calculate_building_unlocks()

func _end_of_turn_actions() -> void:
	# Finish production
	if settlement_data.current_production != "":
		if settlement_data.update_production_progress(settlement_data.current_production, 0.5) >= 1.0:
			var produced : Variant = ResourceRegistry.get_building_or_unit_by_name(settlement_data.current_production)
			if produced is UnitType:
				spawn_unit(produced).parent_hex = parent_hex
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
	print(new_building.building_data.building_modifiers)
	add_child(new_building)
	built_buildings.append(new_building)
	$SettlementDecor.add_building(building_data)
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


func calculate_building_unlocks() -> void:
	#TODO Check researches
	#TODO remove built/obsolete buildings
	
	# Add starting things
	settlement_data.available_buildings = settlement_data.starting_buildings.duplicate(true)
	settlement_data.available_units = settlement_data.starting_units.duplicate(true)

	#Check buildings
	for b: Building in built_buildings:
		for modifier: String in b.building_data.building_modifiers:
			var function: Callable = BuildingModifiers.modifier_dict[modifier]["func"]
			function.call(self, b.building_data.building_modifiers[modifier])
			#print(modifier)

	
	for b: Building in built_buildings:
		settlement_data.available_buildings.erase(b.building_data.building_name.to_lower())


	