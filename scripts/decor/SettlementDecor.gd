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

#region buildings
func add_building(building_data: BuildingData) -> void:
	# at the moment its just a random point, but maybe later allow player to place the buildings as they want
	var sprite : Sprite2D = Sprite2D.new()
	sprite.texture = building_data.building_sprite
	sprite.position = get_random_point()
	$Buildings.add_child(sprite)

func get_random_point() -> Vector2:
	var r: float= 40 * sqrt(randf_range(0,1))
	var theta: float = randf_range(0,1) * 2 * PI
	return Vector2(r * cos(theta), r * sin(theta))
#endregion
