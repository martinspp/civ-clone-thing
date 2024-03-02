extends Camera2D

var camera_speed:int = 500

var pan_point

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_down"):
		self.position.y += camera_speed * delta
	if Input.is_action_pressed("ui_up"):
		self.position.y -= camera_speed * delta
	if Input.is_action_pressed("ui_left"):
		self.position.x -= camera_speed * delta
	if Input.is_action_pressed("ui_right"):
		self.position.x += camera_speed * delta
	
	if Input.is_action_just_pressed('move_map'):
		print(get_global_mouse_position())
		pan_point = get_global_mouse_position()
	if Input.is_action_pressed('move_map') && pan_point:
		self.global_position.x = (global_position.x+pan_point.x) - get_global_mouse_position().x
		self.global_position.y = (global_position.y+pan_point.y) - get_global_mouse_position().y
	if Input.is_action_just_released("move_map"):
		pan_point = null
 

