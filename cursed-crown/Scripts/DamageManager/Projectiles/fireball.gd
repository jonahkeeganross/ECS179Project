class_name  FireBall
extends Node2D

var cur_vel = Vector2.ZERO
var alive_time = 0

@onready var area = $Area2D
@onready var _alive_timer:Timer = $Area2D/AliveTimer
@onready var _delay_timer:Timer  = $Area2D/DelayTimer
@onready var _coll_shape:CollisionShape2D = $Area2D/CollisionShape2D
@onready var _sprite:Sprite2D = $Area2D/Sprite2D

var projectile_array:Array[ProjectileInfo]
var rot = 0
var _projectile_info:ProjectileInfo

var _active = false

func _ready() -> void:
	_delay_timer.timeout.connect(_launch)
	_alive_timer.timeout.connect(_pop_next)
	_delay_timer.one_shot = true
	_alive_timer.one_shot = true

	# Create a simple circular texture for fireball
	if _sprite:
		_sprite.visible = false
		# Create an actual texture image
		var img = Image.create(32, 32, false, Image.FORMAT_RGBA8)
		img.fill(Color(0, 0, 0, 0))  # Transparent background

		# Draw a circle
		for x in range(32):
			for y in range(32):
				var dx = x - 16
				var dy = y - 16
				var distance = sqrt(dx * dx + dy * dy)
				if distance <= 10:
					# Orange/red fireball color with gradient
					var alpha = 1.0 - (distance / 10.0) * 0.3
					img.set_pixel(x, y, Color(1.0, 0.4, 0.0, alpha))

		var texture = ImageTexture.create_from_image(img)
		_sprite.texture = texture
	
	
func initialize(pos:Vector2, info: Array[ProjectileInfo]):
	global_position = pos
	projectile_array = info
	var cur_info = projectile_array.pop_front()
	_projectile_info = cur_info
	_delay_timer.wait_time = cur_info.delay
	_delay_timer.start()
	if not cur_info.target:
		rot = cur_info.rot
	else:
		rot = (cur_info.target.global_position - global_position).angle()
	
func _launch():
	area.body_entered.connect(_on_body_entered)
	_alive_timer.wait_time = _projectile_info.lifetime
	_alive_timer.start()
	alive_time = 0
	_active = true
	_coll_shape.debug_color = Color("e60600ff")

	# Show the fireball sprite
	if _sprite:
		_sprite.visible = true
	
func _physics_process(delta: float) -> void:
	
	#alive_time += delta
	#if _projectile_info:
		#if alive_time > _projectile_info.lifetime:
			#_deactivate()
	if _active and _delay_timer.is_stopped():

		var velocity = Vector2.RIGHT.rotated(deg_to_rad(rot) ) * _projectile_info.speed
		global_position = global_position + velocity * delta
		_projectile_info.speed += (_projectile_info.acceleration * delta)
		#cur_vel = cur_vel + _projectile_info.acceleartion * delta
		rotation = rot
		rot += _projectile_info.rot_vel * delta
		#self.velocity = _projectile_info.velocity 
		#print("LAUNCHING")
		
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

func _deactivate()-> void:
	_active = false
	var tween = self.create_tween()
	tween.tween_property(_sprite, "modulate:a", 0.0, 0.3).set_delay(0.1).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(_destory)
	
func _destory():
	queue_free()

func _on_body_entered(body: Node):

	if body is Character and body.has_method("take_damage") : 
		if body is Player:

			if _projectile_info:
				body.take_damage(_projectile_info.damage)
			
	
	
	
	
