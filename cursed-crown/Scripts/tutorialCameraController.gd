class_name CameraController
extends Camera2D

@export var floating_offset:Vector2 = Vector2.ZERO
@export var top_camera_boundary : Area2D
@export var bottom_camera_boundary : Area2D

var MAX_HEALTH = 100
var _health = 100
var camera_height
var top_boundary
var bottom_boundary

@export var subject:Node2D :
	set(value):
		subject = value
		global_position = subject.global_position + floating_offset

func _ready() -> void:
	global_position = subject.global_position + floating_offset
	#$HealthBar.max_value = MAX_HEALTH
	_health = MAX_HEALTH

func _process(_delta: float) -> void:
	print("PROCESSING")
	camera_height = get_viewport_rect().size.y
	
	top_boundary = top_camera_boundary.global_position.y + camera_height/2
	bottom_boundary = bottom_camera_boundary.global_position.y - camera_height/2
	
	global_position.y = clamp(subject.global_position.y, top_boundary, bottom_boundary)
		
		
func set_health_bar() -> void:
	#print("OK")
	$HealthBar.value = _health

		
func damage(damage: int):
	_health -= damage
	if _health < 0:
		_health = 0
