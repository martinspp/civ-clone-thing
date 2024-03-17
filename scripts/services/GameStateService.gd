extends Node

enum game_states {EDITOR, PLAY}
@onready var current_state = game_states.EDITOR
var editor_service: EditorService
var map_service: MapService
var world_manager: WorldManager
var game_service: GameService
var camera: CameraController

var settlement_registy: Array[Settlement]
var player_registry: Array[Player]

func _ready() -> void:
	randomize()

func start_game() -> Dictionary:
	var ret_msg = {"msg": "", "success": false}
	if world_manager.hexes.get_child_count() < 2:
		return {"msg": "map is not loaded", "success": false}
		
	# Check if players set 
	editor_service.queue_free()
	editor_service = null
	current_state = game_states.PLAY
	# Add players, player stuff
	game_service = GameService.new()
	game_service.set_name("GameService")
	get_node("/root/Main").add_child(game_service)
	
	ret_msg = {"msg": "", "success": true}
	return ret_msg
	
