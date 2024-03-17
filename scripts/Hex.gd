extends Area2D

class_name Hex

enum side_flag {
	top_right = 1,     #0
	right = 2,         #1
	bottom_right = 4,  #2
	bottom_left = 8,   #3
	left = 16,         #4
	top_left = 32      #5
}
static var border_set = [
	Vector2(0,-64),
	Vector2(64,-32),
	Vector2(64, 32),
	Vector2(0, 64),
	Vector2(-64, 32),
	Vector2(-64, -32)
]

static var border_pairs = [[0,1],[1,2],[2,3],[3,4],[4,5],[5,0]]

# inverse_side_lut[source] = target
static var inverse_side_lut = [3,4,5,0,1,2]
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

@onready var sprite: Sprite2D = $Sprite2D
var hex_type: HexType
@onready var rivers: int = 0

@export var collision: CollisionPolygon2D

static var world: WorldManager

var settlement: Settlement

var _q: int = INF
var _r: int = INF

var q:
	get:
		return _q
	set(val):
		_q = val
		update_pos()
var r:
	get:
		return _r
	set(val):
		_r = val
		update_pos()

func _ready() -> void:
	pass

func delete() -> void:
	queue_free()

func update_pos() -> void:
	position.x = (q * 128)+(r*64)
	position.y = r * 96
	
func set_hex_type(type: String):
	hex_type = load("res://resources/HexTypes/%s.tres" % type)
	if hex_type == null:
		hex_type = load("res://resources/HexTypes/delete.tres")
	sprite.texture = hex_type.world_sprite

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if GameStateService.current_state == GameStateService.game_states.EDITOR:
			handle_editor_click(event)
		if GameStateService.current_state == GameStateService.game_states.PLAY:
			handle_play_click(event)

func handle_editor_click(event: InputEvent):
	if event.button_index == 1 && event.pressed == true:
		GameStateService.editor_service.hex_clicked(self, event)
	if event.button_index == 2 && event.pressed == true:
		GameStateService.editor_service.hex_alt_clicked(self, event)
		
func handle_play_click(event: InputEvent):
	if event.button_index == 1 && event.pressed == true:
		PlayEventBus.emit_signal("hex_clicked",self,event)
	
func _on_mouse_entered() -> void:
	if GameStateService.current_state == GameStateService.game_states.EDITOR:
		GameStateService.editor_service.move_editor_cursor(self)

func get_sextant_clicked(event: InputEventMouse) -> side_flag:
	var camera: Camera2D = get_viewport().get_camera_2d()
	var side_angle = rad_to_deg(global_position.angle_to_point(get_global_mouse_position()))+90 # 0 is horizontal right
	if side_angle < 0:
		side_angle += 359 # help
	var side_angle_snapped = snappedf(side_angle,30)
	if side_angle_snapped == 360:
		side_angle_snapped = 0 # i hate myself
	var side = floor(side_angle_snapped / 60)
	return 2**side

func int2bin(value):
	var out = ""
	while (value > 0):
			out = str(value & 1) + out
			value = (value >> 1)
	return out
