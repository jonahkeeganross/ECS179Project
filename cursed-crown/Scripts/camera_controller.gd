class_name CameraController
extends Camera2D

@export var floating_offset:Vector2 = Vector2.ZERO

var MAX_HEALTH = 100
var _health = 100

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
	global_position.x = subject.global_position.x
	global_position.y = subject.global_position.y 

func set_health_bar() -> void:
	print("OK")
	#$HealthBar.value = _health


		
func damage(damage: int):
	_health -= damage
	if _health < 0:
		_health = 0
