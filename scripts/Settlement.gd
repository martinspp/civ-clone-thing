extends Area2D

class_name Settlement

@onready var label: Label = $Label

@onready var settlement_name: String = "New City"
@onready var pop: int = 0
@onready var pop_progress: float = 0.0
@onready var influence_range: int = 1

func _ready() -> void:
	label.text = settlement_name
	
