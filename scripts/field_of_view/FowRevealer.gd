extends Node2D

class_name FowRevealer

@export var fow_range: int

@onready var parent_object: Variant = get_parent()
@onready var revealing_hexes: Array[Hex] = []

static var all_revealed_hexes: Array[Hex] = []

func _ready() -> void:
	#update_revealed_hexes(3)
	pass

func set_revealing(range: int) -> void: 
	revealing_hexes = update_revealed_hexes(range)

func update_revealed_hexes(range: int) -> Array[Hex]:
	if parent_object is Hex:
		return GameStateService.data_service._axial_to_hex_array(Axial.spiral(parent_object.axial, range))
	# god, i need a better thing for this wtf am i doing
	elif parent_object.get_parent() is Hex:
		return GameStateService.data_service._axial_to_hex_array(Axial.spiral(parent_object.get_parent().axial, range))
	else:
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