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

func _build_registries(path: String, registry: Array):
	var resources : PackedStringArray = DirAccess.get_files_at(path)
	for resource_string in resources:
		if resource_string.contains(".tres"):
			var resource : Resource = ResourceLoader.load(path+"/"+resource_string)
			registry.append(resource)
	

func register_building_data(_building: BuildingData):
	print("Not yet implemented")

func register_unit_data(_unit: UnitType):
	print("Not yet implemented")

func get_unit_type_by_name(_name: String) -> UnitType:
	for unit_type in unit_type_registry:
		if unit_type.unit_name == _name:
			return unit_type
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