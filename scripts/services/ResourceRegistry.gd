extends Node

class_name ReesourceRegistry

static var building_data_registry : Array[BuildingData] = []
static var unit_type_registry : Array[UnitType] = []
static var hex_type_registry : Array[HexType] = []
static var research_regsistry : Array[ResearchData] = []

func _ready() -> void:
	_build_registries("res://resources/Buildings", building_data_registry)
	_build_registries("res://resources/Units", unit_type_registry)
	_build_registries("res://resources/HexTypes", hex_type_registry)
	_build_registries("res://resources/Researches", research_regsistry)

func _build_registries(path: String, registry: Array) -> void:
	var resources : PackedStringArray = DirAccess.get_files_at(path)
	for resource_string in resources:
		if resource_string.contains(".tres"):
			var resource : Resource = ResourceLoader.load(path+"/"+resource_string)
			registry.append(resource)
	

func register_building_data(_building: BuildingData) -> void:
	print("Not yet implemented")

func register_unit_data(_unit: UnitType) -> void:
	print("Not yet implemented")

func get_unit_type_by_name(_name: String) -> UnitType:
	for unit_type in unit_type_registry:
		if unit_type.unit_name.to_lower() == _name.to_lower():
			return unit_type
	return null

func get_building_type_by_name(_name: String) -> BuildingData:
	for building_data in building_data_registry:
		print(building_data.building_name)
		if building_data.building_name.to_lower() == _name.to_lower():
			return building_data
	return null


func get_research_by_name(_name: String) -> ResearchData:
	for r in research_regsistry:
		if r.research_name == _name:
			return r
	return null

func get_hextype_by_name(_name: String) -> HexType:
	for h in hex_type_registry:
		if h.data_name == _name:
			return h
	return null

func get_building_or_unit_by_name(_name: String) -> Variant:
	var unit := get_unit_type_by_name(_name)
	if unit:
		return unit
	var building := get_building_type_by_name(_name)
	if building:
		return building
	return null