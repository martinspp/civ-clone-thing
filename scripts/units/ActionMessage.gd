extends RefCounted

class_name ActionMessage

var success: bool
var message: String

func _init(_success: bool, _message: String) -> void:
	self.success = _success
	self.message = _message