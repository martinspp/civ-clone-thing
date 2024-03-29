extends VBoxContainer

class_name PlayerMenu

@export var player_box_scene: PackedScene
@export var player_box_list: VBoxContainer

func clear_list() -> void:
	for i in player_box_list.get_children():
		if i is PlayerBox:
			i.queue_free()

func populate_list() -> void:
	clear_list()
	for player in GameStateService.data_service.get_all_players():
		add_player_box(player)

func add_player_box(new_player: Player) -> void:
	var new_player_box : PlayerBox = player_box_scene.instantiate()
	new_player_box.player_menu = self
	var new_box_index := player_box_list.get_child_count()-1
	player_box_list.add_child(new_player_box)
	new_player_box.update_data(new_player)
	player_box_list.move_child(new_player_box, new_box_index)

# adding new player
func _on_button_pressed() -> void:
	if %PlayerName.text == "":
		return
	var new_player: Player = Player.new(%PlayerName.text, -1, %ColorPickerButton.color)
	%PlayerName.text = ""
	%ColorPickerButton.color = Color.WHITE
	GameStateService.data_service.add_update_player(new_player)
	add_player_box(new_player)
		
func remove_player(player_box: PlayerBox) -> void:
	GameStateService.data_service.remove_player(player_box.player_ref.id)
	populate_list()

#called by player box on changing player
func update_player_boxes() -> void:
	for player_box in player_box_list.get_children():
		if player_box is PlayerBox:
			player_box.update_data(player_box.player_ref)
			player_box.update_set_player_button()