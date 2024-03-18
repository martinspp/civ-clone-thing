class_name Player

var id := randi()
var player_name := "Player"
var color : Color= Color.BLUE

var unlocked_researches : Array[ResearchData] = []
var owned_settlements : Array[Settlement] = []

func _init(_player_name: String, _id, _color) -> void:
    if _id:
        id = _id
    if _color:
        color = _color
    player_name = _player_name
