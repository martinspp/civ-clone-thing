extends PanelContainer

class_name PlayerBox

@export var player_id: Label
@export var player_name: Label
@export var color_picker: ColorPickerButton
@export var settlement_count: Label
@export var research_count: Label
@export var set_current_player: Button

var player_ref: Player
var player_menu: PlayerMenu

func _ready() -> void:
	pass

func update_data(player: Player) -> void:
	player_id.text = str(player.id)
	player_name.text = player.player_name
	color_picker.color = player.color
	settlement_count.text = str(player.owned_settlements.size())
	research_count.text = str(player.unlocked_researches.size())
	player_ref = player

func _on_button_pressed() -> void:
	player_menu.remove_player(self)


func _on_set_current_player_pressed() -> void:
	GameStateService.current_player = player_ref
	player_menu.update_player_boxes()

func update_set_player_button() -> void:
	if GameStateService.current_player && GameStateService.current_player == player_ref:
		set_current_player.disabled = true
	else:
		set_current_player.disabled = false
