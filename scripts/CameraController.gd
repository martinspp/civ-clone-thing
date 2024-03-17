extends Camera2D

var camera_speed:int = 500

var pan_point
@onready var max_zoom:= Vector2(2,2)
@onready var min_zoom:= Vector2(0.5,0.5)
@onready var step_zoom := Vector2(0.1,0.1)
@onready var target_zoom := Vector2(1,1)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if is_focusing:
		focusing(delta)
	else:
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
			target_zoom += step_zoom
		if Input.is_action_just_released("zoom_out"):
			target_zoom -= step_zoom
		target_zoom = clamp(target_zoom,min_zoom,max_zoom)
		self.zoom = target_zoom	
	
var start_focus_point: Vector2
var end_focus_point: Vector2

var start_focus_zoom: float
var end_focus_zoom: float

var is_focusing := false
var focus_progress: float = 0

func focus(point: Vector2, zoom: float):
	start_focus_point = position
	start_focus_zoom = zoom
	
	end_focus_point = point
	end_focus_zoom = zoom
	is_focusing = true
	
	focus_progress = 0
	
func focusing(delta: float):
	position.x = lerpf(start_focus_point.x, end_focus_point.x, focus_progress)
	position.y = lerpf(start_focus_point.y, end_focus_point.y, focus_progress)
	if focus_progress < 1:
		focus_progress += delta
	
func unfocus():
	is_focusing = false
 

