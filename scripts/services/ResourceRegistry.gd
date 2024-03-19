extends Node

class_name ReesourceRegistry

@onready var building_data_registry : Array[BuildingData] = []
@onready var unit_data_registry : Array[UnitData] = []
@onready var hex_type_registry : Array[HexType] = []
@onready var research_regsistry : Array[ResearchData] = []

func _ready() -> void:
    _build_registries("res://resources/Buildings", building_data_registry)
    _build_registries("res://resources/Units", unit_data_registry)
    _build_registries("res://resources/HexTypes", hex_type_registry)
    _build_registries("res://resources/Researches", research_regsistry)

func _build_registries(path: String, registry: Array):
    var resources : PackedStringArray = DirAccess.get_files_at(path)
    for resource_string in resources:
        if resource_string.contains(".tres"):
            var resource : Resource = ResourceLoader.load(path+"/"+resource_string)
            registry.append(resource)
    

func register_building_data(building: BuildingData):
    pass

func register_unit_data(unit: UnitData):
    pass


func get_research_by_name(name: String) -> ResearchData:
    for r in research_regsistry:
        if r.research_name == name:
            return r
    return null