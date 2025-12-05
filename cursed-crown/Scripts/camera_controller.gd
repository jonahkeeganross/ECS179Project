class_name CameraController
extends Camera2D

@export var floating_offset:Vector2 = Vector2.ZERO

var MAX_HEALTH = 100
var cur_pos: Vector2 = Vector2(0,0)
var _health = 100
var _base_mult = 2
var _mult = 2
var _leash_length  = 100


@export var subject:Node2D :
	set(value):
		subject = value
		
		global_position = subject.global_position + floating_offset

func _ready() -> void:
	global_position = subject.global_position + floating_offset
	#$HealthBar.max_value = MAX_HEALTH
	_health = MAX_HEALTH

func _process(_delta: float) -> void:
	#print("PROCESSING")
	cur_pos = cur_pos.lerp(subject.global_position, _delta * _mult)
	if (subject.global_position - cur_pos).length() > _leash_length:
		#print("ALREd")
		_mult = 4
	else:
		_mult = _base_mult
	global_position.x = cur_pos.x
	global_position.y = cur_pos.y

func set_health_bar() -> void:
	print("OK")
	#$HealthBar.value = _health


		
func damage(damage: int):
	_health -= damage
	if _health < 0:
		_health = 0
