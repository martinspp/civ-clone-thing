extends Node

enum game_states {EDITOR, PLAY}
@onready var current_state = game_states.EDITOR
var editor_service: EditorService
var map_service: MapService
var world_manager: WorldManager



var settlement_registy: Array[Settlement]
var player_registry: Array[Player]
@onready var adjusted_mouse_pos: Vector2

func _process(delta: float) -> void:
	if world_manager:
		var camera = get_viewport().get_camera_2d()
		adjusted_mouse_pos = world_manager.get_global_mouse_position() + camera.position + camera.offset - get_viewport().size * 0.5

func start_game() -> Dictionary:
	var ret_msg = {"msg": "", "success": false}
	# Check if map is loaded
	# Check if players set 
	editor_service.queue_free()
	editor_service = null
	current_state = game_states.PLAY
	# Add players, player stuff
	return ret_msg
	
