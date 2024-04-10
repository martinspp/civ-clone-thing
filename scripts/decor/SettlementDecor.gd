extends Node2D

class_name SettlementDecor

@export var settlement: Settlement

@export var villager_scene: PackedScene

func _ready() -> void:
	pass

#region villagers
func update_villager_count(new_count: int) -> void:
	var current_villager_count :int = $Villagers.get_children().size();
	if new_count > current_villager_count:
		spawn_villagers(current_villager_count-new_count);
	elif new_count < current_villager_count:
		remove_villager(current_villager_count-new_count);
	else:
		return
	
func spawn_villagers(count: int) -> void:
	for i in count:
		var villager := villager_scene.instantiate()
		villager._settlement = settlement
		$Villagers.add_child(villager)

func remove_villager(count: int) -> void:
	count = clamp(count, 0, $Villagers.get_children().size())
	for i in count:
		$Villagers.get_children()[0].queue_free()
#endregion
