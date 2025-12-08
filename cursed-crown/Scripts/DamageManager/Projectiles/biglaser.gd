class_name  BigLaser
extends Node2D

var alive_time = 0

@onready var area = $Area2D
@onready var _alive_timer:Timer = $Area2D/AliveTimer
@onready var _delay_timer:Timer  = $Area2D/DelayTimer
@onready var _coll_shape:CollisionShape2D = $Area2D/CollisionShape2D
@onready var _display_sprite:Sprite2D = $Area2D/Sprite2D


var rect_shape: RectangleShape2D
var prefire_color: Color
var fire_color: Color
var _projectile_info:ProjectileInfo
var _active = false
var _can_do_dmg = false
var projectile_array:Array[ProjectileInfo]
var rot = 0;
var initial_pos:Vector2 = Vector2.ZERO

func _ready() -> void:
	_delay_timer.timeout.connect(_launch)
	_alive_timer.timeout.connect(_deactivate)
	_delay_timer.one_shot = true
	_alive_timer.one_shot = true
	rect_shape = RectangleShape2D.new()
	rect_shape.size = Vector2(2000,1)
	_coll_shape.shape = rect_shape
	#_coll_shape.debug_color = Color("ffffffff")

	# Create laser texture
	if _display_sprite:
		_display_sprite.visible = true
		# Create a simple rectangular laser beam texture
	
	
func initialize(pos:Vector2, info: Array[ProjectileInfo]):
	projectile_array = info
	initial_pos = pos
	
	var cur_info = projectile_array.pop_front()
	_projectile_info = cur_info
	_delay_timer.wait_time = cur_info.delay
	_delay_timer.start()
	rot = _projectile_info.rot
	var angle_rad = deg_to_rad( _projectile_info.rot)
	rotation = angle_rad 
	
	var img = Image.create(10, 10, false, Image.FORMAT_RGBA8)
	# Fill with bright red/orange for laser beam
	img.fill(Color(1.0, 1.0, 1.0, 0.9))

	var texture = ImageTexture.create_from_image(img)
	_display_sprite.texture = texture
	_display_sprite.centered = false  # Align to left edge
	_display_sprite.modulate = Color(1, 1, 1, 1)
	var dir = Vector2.RIGHT.rotated(angle_rad)
	
	var half_len = (rect_shape.size.x * abs(global_scale.x)) * 0.5
	
	global_position = pos +   dir  * half_len
	var beam_length = rect_shape.size.x
	var beam_width = rect_shape.size.y
	_display_sprite.scale = Vector2(beam_length / 10.0, beam_width / 10.0)
	_display_sprite.position = Vector2(-beam_length / 2.0, -beam_width / 2.0)
	_active = true
	#if not cur_info.target:
		#rot = cur_info.rot
	#else:
		#rot = (cur_info.target.global_position - global_position).angle()
func _launch():
	area.body_entered.connect(_on_body_entered)
	_alive_timer.wait_time = _projectile_info.lifetime
	_alive_timer.start()
	alive_time = 0
	for body in area.get_overlapping_bodies():
			_on_body_entered(body) 
	
	var tween = create_tween()
	tween.tween_property(_display_sprite, "modulate", Color(0.667, 0.0, 0.925, 1.0) , 0.3).set_trans(Tween.TRANS_QUAD)
	#_coll_shape.debug_color = Color("e60600ff")
	rect_shape.size = Vector2(2000,80)

	# Fill with bright red/orange for laser beam

	# Show and scale the laser sprite
	if _display_sprite:
		_display_sprite.visible = true
		# Scale the texture to match the collision shape
		var beam_length = rect_shape.size.x
		var beam_width = rect_shape.size.y
		var tween2 = create_tween()
		var new_scale = Vector2(beam_length / 10.0, beam_width / 10.0)
		tween2.tween_property(_display_sprite, "scale", new_scale, 0.2)
		#_display_sprite.scale = Vector2(beam_length / 10.0, beam_width / 10.0)
		_display_sprite.position = Vector2(-beam_length / 2.0, -beam_width / 2.0)
		
		

	
func _physics_process(delta: float) -> void:
	if _active :
		var angle_rad = deg_to_rad(rot)
		
		rotation = angle_rad
		
		rot += _projectile_info.rot_vel * delta
		
		var dir = Vector2.RIGHT.rotated(angle_rad)
	
		var half_len = (rect_shape.size.x * abs(global_scale.x)) * 0.5
		global_position = initial_pos +   dir  * half_len
func _deactivate()-> void:
	#print("DYING")
	_active = false
	queue_free()

func _on_body_entered(body: Node):

	if body is Character and body.has_method("take_damage") : 
		if body is Player:
			if _projectile_info:
				body.take_damage(_projectile_info.damage)
			
	
	
	
	
