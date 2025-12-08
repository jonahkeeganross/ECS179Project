class_name FireBall
extends Node2D

var cur_vel = Vector2.ZERO
var alive_time = 0

@onready var area = $Area2D
@onready var _alive_timer: Timer = $Area2D/AliveTimer
@onready var _delay_timer: Timer  = $Area2D/DelayTimer
@onready var _coll_shape: CollisionShape2D = $Area2D/CollisionShape2D

@onready var _sprite: Sprite2D = $Area2D/Sprite2D
@onready var fire: AnimatedSprite2D = $Area2D/fire

var projectile_array: Array[ProjectileInfo]
var rot = 0
var _projectile_info: ProjectileInfo

var _active = false

func _ready() -> void:
	_delay_timer.timeout.connect(_launch)
	_alive_timer.timeout.connect(_pop_next)
	_delay_timer.one_shot = true
	_alive_timer.one_shot = true

	
	if _sprite:
		_sprite.visible = false

	if fire:
		fire.visible = false
		fire.modulate.a = 0.0
		fire.stop()


func initialize(pos: Vector2, info: Array[ProjectileInfo]) -> void:
	global_position = pos
	projectile_array = info

	var tween = self.create_tween()
	if fire:
		# Fade in the animated fireball
		tween.tween_property(fire, "modulate:a", 1.0, 0.3) \
			.set_delay(0.1).set_trans(Tween.TRANS_QUAD)

	var cur_info = projectile_array.pop_front()
	_projectile_info = cur_info
	_delay_timer.wait_time = cur_info.delay
	_delay_timer.start()

	if not cur_info.target:
		rot = cur_info.rot
	else:
		rot = (cur_info.target.global_position - global_position).angle()


func _launch() -> void:
	area.body_entered.connect(_on_body_entered)
	_alive_timer.wait_time = _projectile_info.lifetime
	_alive_timer.start()
	alive_time = 0
	_active = true
	_coll_shape.debug_color = Color("e60600ff")


	if fire:
		fire.visible = true
		fire.play() 


func _physics_process(delta: float) -> void:
	if _active and _delay_timer.is_stopped():
		var velocity = Vector2.RIGHT.rotated(deg_to_rad(rot)) * _projectile_info.speed
		global_position += velocity * delta
		_projectile_info.speed += (_projectile_info.acceleration * delta)
		rotation = rot
		rot += _projectile_info.rot_vel * delta


func _pop_next() -> void:
	if projectile_array.size() == 0:
		_deactivate()
		return

	var cur_info = projectile_array.pop_front()
	_projectile_info = cur_info

	if not cur_info.target:
		rot = cur_info.rot
	else:
		rot = rad_to_deg((cur_info.target.global_position - global_position).angle())

	rotation = rot
	_launch()


func _deactivate() -> void:
	_active = false
	var tween = self.create_tween()

	if fire:
		
		tween.tween_property(fire, "modulate:a", 0.0, 0.3) \
			.set_delay(0.1).set_trans(Tween.TRANS_QUAD)
	else:
		
		tween.tween_interval(0.3)

	tween.tween_callback(_destory)


func _destory() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body is Character and body.has_method("take_damage"):
		if body is Player and _projectile_info:
			body.take_damage(_projectile_info.damage)
