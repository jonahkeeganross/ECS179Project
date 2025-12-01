class_name Vampire
extends Character

@export var player:Player

var health:int = 100
var target : Character
var cmd_list : Array[Command]

var move_rl_input: float
var move_ud_input: float
var is_moving: bool = false
#var player:Node2D = GameState.player
var enabled: bool
var _facing_dir = Facing.RIGHT
var _dead:bool = false
var _test_dt = 0

#@onready var audio_player:AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	add_to_group("Enemies")
	add_to_group("Vampire")
	bind_vampire_commands()
	movement_speed = 50


func _process(_delta):
	_test_dt += _delta
	if _test_dt > 3:
		animation_player.play("attack")
		_test_dt = 0
	if _dead:
		if !animation_player.is_playing():
			sprite.visible = false
		return
	if Facing.LEFT == facing:
		scale.y = 1.0
		rotation_degrees = 0.0
	elif Facing.RIGHT == facing:
		scale.y = 1.0
		#rotation_degrees = -180.0


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
	var dir = (player.global_position - global_position)
	var projectile_list:Array[ProjectileInfo] = []
	var projectile_spawn = ProjectileInfo.new(
		CharacterSpec.spec.ENEMY, 
		10, # damage
		1, # Lifetime
		0.01, # Spawn delay
		180, # Speed
		-180, # Acceleration
		0, # Initial Rotation
		0 # Initial Rot velocity 
	)
	var projectile_shoot = ProjectileInfo.new(
		CharacterSpec.spec.ENEMY, 
		10, # damage
		7, # Lifetime
		0.01, # Spawn delay
		20, # Speed
		70, # Acceleration
		0, # Initial Rotation
		0, # Initial Rot velocity 
		player
	)
	projectile_list.append(projectile_spawn)
	projectile_list.append(projectile_shoot)
	
	BUS.emit_signal("spawn_fireball", global_position, projectile_list)
#func command_callback(command_name:String) -> void:
	#if "summon" == command_name:
		#audio_player.stop()
		#audio_player["parameters/switch_to_clip"] = "yell1"
		#audio_player.play()
	#if "jump" == command_name:
		#audio_player.stop()
		#audio_player["parameters/switch_to_clip"] = "blast"
		#audio_player.play()
