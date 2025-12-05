class_name Vampire
extends Character

@onready var stun_timer:Timer = $StunTime
@onready var health_bar:ProgressBar = $HealthBar
#@onready var  
enum State {IDLE, CHASE, ATTACK, STUN, DEAD}

var state:State

var health:int = 100
var target : Character
var cmd_list : Array[Command]

var move_rl_input: float
var move_ud_input: float
var is_moving: bool = false
var is_attacking: bool = false
var player:Node2D = GameState.player
var enabled: bool
var _facing_dir = Facing.RIGHT
var _dead:bool = false
var _test_dt = 0
var attack_speed = 2
var cur_time = 1
var _knockback_velocity: Vector2


#@onready var audio_player:AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	add_to_group("Enemies")
	add_to_group("Vampire")
	bind_vampire_commands()
	movement_speed = 50


func _process(_delta):
	if _dead:
		remove_from_group("Enemies")
		$CollisionShape2D.disabled = true
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
	match state:
		State.DEAD:
			if _dead:
				$NavigationAgent2D.set_velocity(Vector2.ZERO)
				return
				
		State.IDLE, State.CHASE, State.ATTACK:		
			if is_moving:
				var facing_dir = global_position.x - player.global_position.x
				if facing_dir < 0:
					facing = Facing.LEFT
				else: facing = Facing.RIGHT
				
				$NavigationAgent2D.target_position = player.global_position
				var next_path_point = $NavigationAgent2D.get_next_path_position()
				var direction = (next_path_point - global_position).normalized()
				velocity = direction * movement_speed
				move_and_slide()
			else:
				self.velocity = Vector2(0, 0)
				$NavigationAgent2D.set_velocity(Vector2.ZERO)
				$NavigationAgent2D.target_position = global_position
				
			if attacking:
				if cur_time > 2:
					spawn_fireball_bite()
					cur_time = 0
				cur_time += delta
		State.STUN:
			process_knockback(delta)
	super(delta)
	
func _deactivate():
	var tween = self.create_tween()
	tween.tween_property(health_bar, "modulate:a", 0.0, 0.8).set_delay(0.1).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(_destory)

func _destory():
	#queue_free()
	print("destroy?")


func bind_vampire_commands():
	right_cmd = MoveRightCommand.new()
	left_cmd = MoveLeftCommand.new()
	up_cmd = MoveUpCommand.new()
	down_cmd = MoveDownCommand.new()


func take_damage(damage:int):
	health -= damage
	if 0 >= health:
		_deactivate()
		_dead = true
		state = State.DEAD
		velocity = Vector2.ZERO
		animation_player.play("death")
	health_bar.value  = health
		

func apply_knockback(dir:Vector2 ,strength:float, timer:float = 0.3):
	if not _dead:
		_knockback_velocity = -dir * strength
		state = State.STUN
		stun_timer.start()
		
	
func process_knockback(delta:float):
	velocity = _knockback_velocity
	#_knockback_velocity = _knockback_velocity.lerp(Vector2.ZERO, delta)
	_knockback_velocity = _knockback_velocity.move_toward(Vector2.ZERO, 2000.0 * delta)
	if _knockback_velocity == Vector2.ZERO:
		state = State.CHASE
		

func _stun_timeout():
	_knockback_velocity = Vector2.ZERO
	state = State.CHASE


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
