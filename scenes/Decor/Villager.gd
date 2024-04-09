extends AnimatedSprite2D


class_name VillagerDecor

var SPEED :float = 15
var _settlement: Settlement

var target_point :Vector2 = Vector2.ZERO
var next_pos :Vector2
var waiting :float = 0

func _process(delta: float) -> void:
	if waiting >= 0:
		play('idle')
		waiting -= delta
	else:
		next_pos = position.move_toward(target_point, SPEED*delta)
		var walk_angle :float= rad_to_deg(position.angle_to_point(target_point))
		if walk_angle >= 0 && walk_angle <= 90 || walk_angle <= 270 && walk_angle >= 180:
			play("walkR")
		else:
			play("walkL")
		position = next_pos

		if target_point == position:
			target_point = get_random_point()
			waiting = randf_range(0.2, 2)


func get_random_point() -> Vector2:
	var r: float= 40 * sqrt(randf_range(0,1))
	var theta: float = randf_range(0,1) * 2 * PI
	return Vector2(r * cos(theta), r * sin(theta))
