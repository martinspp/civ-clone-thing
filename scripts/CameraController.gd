extends Camera2D

class_name CameraController

var camera_speed:int = 500

var pan_point: Variant
@onready var max_zoom:= Vector2(2,2)
@onready var min_zoom:= Vector2(0.5,0.5)
@onready var step_zoom := Vector2(0.1,0.1)
@onready var target_zoom := Vector2(1,1)

func _ready() -> void:
	GameStateService.camera = self

func _process(delta: float) -> void:
	if !is_focusing:
		if Input.is_action_pressed("ui_down"):
			self.position.y += camera_speed * delta
		if Input.is_action_pressed("ui_up"):
			self.position.y -= camera_speed * delta
		if Input.is_action_pressed("ui_left"):
			self.position.x -= camera_speed * delta
		if Input.is_action_pressed("ui_right"):
			self.position.x += camera_speed * delta

		if Input.is_action_just_pressed('move_map'):
			pan_point = get_global_mouse_position()
		if Input.is_action_pressed('move_map') && pan_point:
			self.global_position.x = (global_position.x+pan_point.x) - get_global_mouse_position().x
			self.global_position.y = (global_position.y+pan_point.y) - get_global_mouse_position().y
		if Input.is_action_just_released("move_map"):
			pan_point = null

		if Input.is_action_just_released("zoom_in"):
			zoom += step_zoom
		if Input.is_action_just_released("zoom_out"):
			zoom -= step_zoom
	zoom = clamp(zoom,min_zoom,max_zoom)
	
var start_focus_point: Vector2
var end_focus_point: Vector2

var start_focus_zoom: float
var end_focus_zoom: float

var is_focusing := false
var focus_progress: float = 0

func focus_settlement(point: Vector2, focus_zoom: Vector2) -> void:
	is_focusing = true

	var tween :Tween= get_tree().create_tween()
	tween.tween_property(self, "position", point, 0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(self, "zoom", focus_zoom, 0.75).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	
func unfocus_settlement() -> void:
	var tween :Tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2(1,1), 0.2).set_ease(Tween.EASE_IN_OUT)
	is_focusing = false
 

