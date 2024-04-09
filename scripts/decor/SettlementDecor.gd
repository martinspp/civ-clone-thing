extends Node2D

class_name SettlementDecor

@export var settlement: Settlement

@export var villager_scene: PackedScene

func _ready() -> void:
	pass

func update_villager_count() -> void:
	pass
	
func spawn_villagers(count: int) -> void:
	for i in count:
		var villager := villager_scene.instantiate()
		villager._settlement = settlement
		$Villagers.add_child(villager)

func remove_villager(count: int) -> void:
	count = clamp(count, 0, $Villagers.get_children().size())
	for i in count:
		$Villagers.get_children()[0].queue_free()