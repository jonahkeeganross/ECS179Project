class_name Vampire
extends Character


@export var player : Player
@export var projectile_manager:ProjectileManager


var health:int = 100
var target : Character
var cmd_list : Array[Command]
var db_time:float = 0
var move_rl_input: float
var move_ud_input: float
var is_moving: bool = false
var _facing_dir = Facing.RIGHT

var _dead:bool = false

#@onready var audio_player:AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	add_to_group("Enemies")
	bind_vampire_commands()
	movement_speed = 50


func _process(_delta):
	db_time += _delta
	if db_time > 3:
		animation_player.play("attack")
		animation_player.queue("attack")
		animation_player.queue("attack")
		db_time = 0
	if _dead:
		if !animation_player.is_playing():
			sprite.visible = false
		return
	if facing == Facing.LEFT :
		print("EFT")
		scale.y = -1.0
		rotation_degrees = -180
	elif facing == Facing.RIGHT :
		scale.y = 1.0
		rotation_degrees = 0


func _physics_process(delta: float):
	
	if _dead:
		return
	
		
		
	if is_moving:
		$NavigationAgent2D.target_position = player.global_position
		var next_path_point = $NavigationAgent2D.get_next_path_position()
		var direction = (next_path_point - global_position).normalized()
		velocity = direction * movement_speed
		move_and_slide()

	else:
		self.velocity = Vector2(0, 0)

	super(delta)


func bind_vampire_commands():
	right_cmd = MoveRightCommand.new()
	left_cmd = MoveLeftCommand.new()
	up_cmd = MoveUpCommand.new()
	down_cmd = MoveDownCommand.new()


func take_damage(damage:int):
	health -= damage
	if 0 >= health:
		_dead = true
		velocity = Vector2.ZERO
		animation_player.play("death")

func spawn_fireball_bite():
	var dir_mult = 1
	var rot_mult = 0
	if _facing_dir == Facing.LEFT:
		dir_mult = -1
		rot_mult = -180
	var dir = (player.global_position - global_position - Vector2(dir_mult * 90,0)).angle()
	var projectile_list:Array[ProjectileInfo] = []
	var projectile_spawn = ProjectileInfo.new(
		CharacterSpec.spec.ENEMY, 
		10, # damage
		1, # Lifetime
		0.01, # Spawn delay
		180, # Speed
		-180, # Acceleration
		rot_mult, # Initial Rotation
		0 # Initial Rot velocity 
		)
	var projectile_shoot = ProjectileInfo.new(
		CharacterSpec.spec.ENEMY, 
		10, # damage
		7, # Lifetime
		0.01, # Spawn delay
		20, # Speed
		70, # Acceleration
		rad_to_deg(dir), # Initial Rotation
		0 # Initial Rot velocity 
	)
	projectile_list.append(projectile_spawn)
	projectile_list.append(projectile_shoot)
	#projectile_manager.spawn_laser(global_position, projectile_info)
	BUS.emit_signal("spawn_fireball",global_position, projectile_list)
#func command_callback(command_name:String) -> void:
	#if "summon" == command_name:
		#audio_player.stop()
		#audio_player["parameters/switch_to_clip"] = "yell1"
		#audio_player.play()
	#if "jump" == command_name:
		#audio_player.stop()
		#audio_player["parameters/switch_to_clip"] = "blast"
		#audio_player.play()
