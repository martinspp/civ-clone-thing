extends Node

enum game_states {EDITOR, PLAY}
@onready var current_state = game_states.EDITOR
var editor_service: EditorService
var data_service: DataService
var world_manager: WorldManager
var game_service: GameService
var camera: CameraController

var settlement_registy: Array[Settlement]
#var player_registry: Array[Player]

var current_player: Player

func _ready() -> void:
	randomize()
	

func start_game() -> Dictionary:
	#var ret_msg = {"msg": "", "success": false}
	if world_manager.hexes.get_child_count() < 2:
		return {"msg": "map is not loaded", "success": false}
	if data_service.world_dict.has("player_data") && data_service.world_dict["player_data"].has("players"):
		for player in data_service.world_dict["player_data"]["players"]:
			print("Player name: %s  id: %s " % [data_service.world_dict["player_data"]["players"][player]["player_name"], data_service.world_dict["player_data"]["players"][player]["id"]])
	
	# Check if players set 
	editor_service.queue_free()
	editor_service = null
	current_state = game_states.PLAY
	# Add players, player stuff
	game_service = GameService.new()
	game_service.set_name("GameService")
	get_node("/root/Main").add_child(game_service)
	
	return {"msg": "", "success": true}
	

func get_settlement_by_id(id: int) -> Settlement:
	for s in settlement_registy:
		if s.id == id:
			return s
	return null

#func get_player_by_id(id: int) -> Player:
#	for p in player_registry:
#		if p.id == id:
#			return p
#	return null
#
#func remove_player_by_id(id: int) -> void:
#	for p in player_registry:
#		if p.id == id:
#			player_registry.erase(p)