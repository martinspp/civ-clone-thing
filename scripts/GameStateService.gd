extends Node

enum game_states {EDITOR, PLAY}
@onready var current_state = game_states.EDITOR
var editor_service: EditorService
var map_service: MapService
var world_manager: WorldManager

var settlement_registy: Array[Settlement]
var player_registry: Array[Player]
