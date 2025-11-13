class_name  FireBall
extends Node2D

var cur_vel = Vector2.ZERO
var alive_time = 0

@onready var area = $Area2D
@onready var _alive_timer:Timer = $Area2D/AliveTimer
@onready var _delay_timer:Timer  = $Area2D/DelayTimer
@onready var _coll_shape:CollisionShape2D = $Area2D/CollisionShape2D

var _projectile_info:ProjectileInfo

var _active = false

func _ready() -> void:
	_delay_timer.timeout.connect(_launch)
	_alive_timer.timeout.connect(_deactivate)
	_delay_timer.one_shot = true
	_alive_timer.one_shot = true
	
	
func initialize(pos:Vector2, info: ProjectileInfo):
	global_position = pos
	_projectile_info = info
	_delay_timer.wait_time = info.delay
	_delay_timer.start()
	rotation = deg_to_rad(info.rot)
	
func _launch():
	area.body_entered.connect(_on_body_entered)
	_alive_timer.wait_time = _projectile_info.lifetime
	_alive_timer.start()
	alive_time = 0
	_active = true
	_coll_shape.debug_color = Color("e60600ff")
	
func _physics_process(delta: float) -> void:
	#alive_time += delta
	#if _projectile_info:
		#if alive_time > _projectile_info.lifetime:
			#_deactivate()
	if _active and _delay_timer.is_stopped():
		var velocity = Vector2.RIGHT.rotated(deg_to_rad(_projectile_info.rot) ) * _projectile_info.speed
		global_position = global_position + velocity * delta
		_projectile_info.speed += (_projectile_info.acceleration * delta)
		#cur_vel = cur_vel + _projectile_info.acceleartion * delta
		rotation = _projectile_info.rot
		_projectile_info.rot += _projectile_info.rot_vel * delta
		#self.velocity = _projectile_info.velocity 
		#print("LAUNCHING")
		
func _deactivate()-> void:
	_active = false
	queue_free()

func _on_body_entered(body: Node):

	if body is Character and body.has_method("take_damage") : 
		if body is Player:

			if _projectile_info:
				body.take_damage(_projectile_info.damage)
			
	
	
	
	
