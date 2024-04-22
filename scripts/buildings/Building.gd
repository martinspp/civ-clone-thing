extends Node2D

class_name Building

@onready var building_data: BuildingData:
    get:
        return building_data
    set(value):
        building_data = value
        _update_data()
        
@onready var settlement: Settlement = get_parent()

func _ready() -> void:
    set_meta('type', 'building')

func _update_data() -> void:
    print("building set")
    name = building_data.building_name