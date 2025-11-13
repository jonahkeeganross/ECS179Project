class_name VectorCalc


static func get_unit_from_ang(deg: float) -> Vector2: # gets the unit vector from angle
	var _rad = deg_to_rad(deg)
	return Vector2(cos(_rad), sin(_rad))
