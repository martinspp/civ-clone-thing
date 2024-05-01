extends Node2D

class_name FowRevealer

@onready var fow_range: int = 0 

@onready var parent_object: Variant = get_parent()
@onready var revealing_hexes: Array[Hex] = []

static var all_revealed_hexes: Array[Hex] = []

func _ready() -> void:
	pass

# Updates the ranged based on parent type
func update_range() -> void:
	if parent_object is Unit:
		fow_range = parent_object.unit_data.fow_range
	elif parent_object is Settlement:
		fow_range = 3


func update_revealing() -> void:
	revealing_hexes = _update_revealed_hexes(fow_range)

func _update_revealed_hexes(reveal_range: int) -> Array[Hex]:
	if parent_object is Hex:
		return GameStateService.data_service._axial_to_hex_array(Axial.spiral(parent_object.axial, reveal_range))
	# god, i need a better thing for this wtf am i doing
	elif parent_object.get_parent() is Hex:
		return GameStateService.data_service._axial_to_hex_array(Axial.spiral(parent_object.get_parent().axial, reveal_range))
	elif parent_object is Unit:
		return GameStateService.data_service._axial_to_hex_array(Axial.spiral(parent_object.parent_hex.axial, reveal_range))
	else:
		print("Parent Hex not found")
		return []

static func calculate_revealed_hexes() -> void:
	var revealers: Array[Node] = GameStateService.get_tree().get_nodes_in_group("FowRevealers")
	all_revealed_hexes.clear()
	for r in revealers:
		all_revealed_hexes.append_array(r.revealing_hexes)
		
static func reveal_revealed_hexes() -> void:
	calculate_revealed_hexes()
	for h in all_revealed_hexes:
		h.get_node("FowHider").reveal()