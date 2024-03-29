extends Area2D

class_name Hex
#region sides
enum side_flag {
	top_right = 1,     #0
	right = 2,         #1
	bottom_right = 4,  #2
	bottom_left = 8,   #3
	left = 16,         #4
	top_left = 32      #5
}
static var border_set : Array[Vector2]= [
	Vector2(0,-64),
	Vector2(64,-32),
	Vector2(64, 32),
	Vector2(0, 64),
	Vector2(-64, 32),
	Vector2(-64, -32)
]

static var border_pairs := [[0,1],[1,2],[2,3],[3,4],[4,5],[5,0]]

# inverse_side_lut[source] = target
static var inverse_side_lut : Array[int]= [3,4,5,0,1,2]
#static var side_index=[1,2,4,8,16,32]
static func get_side_index(side: side_flag) -> int:
	# theres gotta be a better way of doing this
	if side & Hex.side_flag.top_right:
		return 0
	elif side & Hex.side_flag.right:
		return 1
	elif side & Hex.side_flag.bottom_right:
		return 2
	elif side & Hex.side_flag.bottom_left:
		return 3
	elif side & Hex.side_flag.left:
		return 4
	elif side & Hex.side_flag.top_left:
		return 5
	return -1

#endregion

@onready var rivers: int = 0
var hex_type: HexType:
	get:
		return hex_type
	set(value):
		hex_type = value
		if value:
			sprite.texture = hex_type.world_sprite
		else:
			hex_type = load("res://resources/HexTypes/delete.tres")


@onready var sprite: Sprite2D = $Sprite2D
@export var collision: CollisionPolygon2D

static var world: WorldManager

var settlement: Settlement
@onready var units: Array[Unit] = []

var q:int:
	get:
		return q
	set(val):
		q = val
		update_pos()
var r :int:
	get:
		return r
	set(val):
		r = val
		update_pos()

func delete() -> void:
	queue_free()

func update_pos() -> void:
	if q == null || r == null:
		return
	position.x = (q * 128)+(r*64)
	position.y = r * 96
	world.astar.add_point(get_instance_id(), position)
	connect_neighbours()
	name = "Hex (r %s, q %s)" % [r,q] 


func set_hex_type_by_string(type: String) -> void:
	hex_type = load("res://resources/HexTypes/%s.tres" % type)
	if hex_type.traversable:
		world.astar.set_point_disabled(get_instance_id(), false)
	else:
		world.astar.set_point_disabled(get_instance_id(), true)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if GameStateService.current_state == GameStateService.game_states.EDITOR:
			handle_editor_click(event)
		if GameStateService.current_state == GameStateService.game_states.PLAY:
			handle_play_click(event)

func handle_editor_click(event: InputEvent) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT && event.pressed == true:
		GameStateService.editor_service.hex_clicked(self, event)
	if event.button_index == MOUSE_BUTTON_RIGHT && event.pressed == true:
		GameStateService.editor_service.hex_alt_clicked(self, event)
		
func handle_play_click(event: InputEvent) -> void:
	if event.button_index == 1 && event.pressed == true:
		PlayEventBus.emit_signal("hex_clicked",self,event)
	
func _on_mouse_entered() -> void:
	if GameStateService.current_state == GameStateService.game_states.EDITOR:
		GameStateService.editor_service.move_editor_cursor(self)

func get_sextant_clicked(_event: InputEventMouse) -> side_flag:
	var side_angle: float = rad_to_deg(global_position.angle_to_point(get_global_mouse_position()))+90 # 0 is horizontal right
	if side_angle < 0:
		side_angle += 359 # help
	var side_angle_snapped :float = snappedf(side_angle,30)
	if side_angle_snapped == 360:
		side_angle_snapped = 0 # i hate myself
	var side := int(floor(side_angle_snapped / 60))
	return 2**side as side_flag

# was used for debugging rivers
func int2bin(value: int) -> String:
	var out :String = ""
	while (value > 0):
		out = str(value & 1) + out
		value = (value >> 1)
	return out

func connect_neighbours() -> void:
	for neighbour: Hex in GameStateService.data_service.get_all_neighbouring_hexes(self):
		world.astar.connect_points(get_instance_id(), neighbour.get_instance_id())
