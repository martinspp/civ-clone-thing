extends PanelContainer

class_name PlayerBox

@export var player_id: Label
@export var player_name: Label
@export var color_picker: ColorPickerButton
@export var settlement_count: Label
@export var research_count: Label
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
