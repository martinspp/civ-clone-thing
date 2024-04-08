extends Node

enum game_states {EDITOR, PLAY}
@onready var current_state : game_states= game_states.EDITOR
var editor_service: EditorService
var data_service: DataService
var world_manager: WorldManager
var game_service: GameService
var camera: CameraController

var settlement_registy: Array[Settlement]
#var player_registry: Array[Player]

#List of objects that need to perform actions to start the next turns
@onready var end_of_turn_actions : Dictionary = {}

var current_player: Player:
	get: 
		return current_player
	set(value):
		current_player = value
		PlayEventBus.current_player_changed.emit(value)


func _ready() -> void:
	randomize()

func start_game() -> Dictionary:
	#var ret_msg = {"msg": "", "success": false}
	if world_manager.hexes.get_child_count() < 2:
		return {"msg": "map is not loaded", "success": false}
	if data_service.world_dict.has("player_data") && data_service.world_dict["player_data"].has("players"):
		for player : String in data_service.world_dict["player_data"]["players"]:
			print("Player name: %s  id: %s " % [data_service.world_dict["player_data"]["players"][player]["player_name"], data_service.world_dict["player_data"]["players"][player]["id"]])
	if data_service.get_all_players().size() < 1:
		return {'msg': "Need at least 1 players to start", "success": false}
	if current_player == null:
		current_player = data_service.get_all_players()[0]

	#clear editor things
	editor_service.queue_free()
	editor_service = null
	current_state = game_states.PLAY

	#add game stuff
	game_service = GameService.new()
	get_node("/root/Main").add_child(game_service)
	
	PlayEventBus.start_of_turn.emit(1)
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