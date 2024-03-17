extends Node

class_name Player

var id := randi()
var player_name := "Player"
var color : Color= Color.BLUE

var unlocked_researches : Array[ResearchData] = []
var owned_settlements : Array[Settlement] = []

func _ready() -> void:
    pass

