extends Area2D

class_name Settlement

@onready var label: Label = $Label

@onready var settlement_data: SettlementData = SettlementData.new()

func _ready() -> void:
	label.text = settlement_data.settlement_name
	
