extends Node

enum game_states {EDITOR, PLAY}
@onready var current_state = game_states.EDITOR
var editor_service: EditorService
var map_service: MapService

