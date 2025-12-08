class_name Skeleton
extends Character

@export var coin_factory : PackedScene

@onready var stun_timer:Timer = $StunTime
@onready var health_bar:ProgressBar = $HealthBar
@onready var atk_hitbox:EnemyHitBox = $CircularAttackHB
@onready var animation_tree:AnimationTree = $AnimationTree
@onready var skeleton_attack: AudioStreamPlayer2D = $skeletonAttack
@onready var skeleton_death: AudioStreamPlayer2D = $skeletonDeath


#@onready var  
enum State {IDLE, CHASE, ATTACK, STUN, DEAD}

var state:State
var health:int = 100
var max_health:int = 100
var target : Character
var cmd_list : Array[Command]

var move_rl_input: float
var move_ud_input: float
var is_moving: bool = false
var is_attacking: bool = false
var _facing_dir
var _dead:bool = false
var player = GameState.player
var enabled: bool
var _knockback_velocity: Vector2
var cur_time = 2
var coin_drop_chance = 0.4
var coin_spawned = false
var rng:RandomNumberGenerator
#@onready var audio_player:AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	rng = RandomNumberGenerator.new()
	#$CollisionShape2D.disabled = true
	print("READY")
	add_to_group("Enemies")
	add_to_group("Skeleton")
	set_physics_process(false)
	set_process(false)
	state = State.IDLE
	
	bind_skeleton_commands()
	var fast = rng.randi_range(0, 4)
	var bonus_s = rng.randi_range(-5,5)
	movement_speed = 30 + bonus_s
	if fast == 4:
		movement_speed = 50
		health = 50
		max_health = 50
	stun_timer.timeout.connect(_stun_timeout)
	
func _process(_delta):
	if _dead:
		$NavigationAgent2D.set_velocity(Vector2.ZERO)
		remove_from_group("Enemies")
		$CollisionShape2D.disabled = true
		if !animation_player.is_playing():
			sprite.visible = false
		if animation_player.is_playing():
			if animation_player.current_animation == "attack":
				animation_player.play("death")
				
		
		if coin_spawned == false:
			chance_coin()
			coin_spawned = true
		
		await get_tree().create_timer(1).timeout
		
		return
	if Facing.LEFT == facing:
		scale.y = 1.0
		rotation_degrees = 0.0
		sprite.flip_h = false
	elif Facing.RIGHT == facing:
		scale.y = 1.0
		sprite.flip_h = true

func _physics_process(delta: float):
	if not enabled:

		return 
	
	match state:
		State.DEAD:
			if _dead:
				$NavigationAgent2D.set_velocity(Vector2.ZERO)
				return
				
		State.IDLE, State.CHASE:	
			if not is_attacking:	
				var distance = (global_position - player.global_position).length()
				var y_dist = global_position.y - player.global_position.y
				atk_hitbox.monitoring = true
				if distance > 25 or abs(y_dist) > 10 :
					set_animation("walk")
					var facing_dir = global_position.x - player.global_position.x
					if facing_dir < 0:
						facing = Facing.LEFT
						
					else: 
						facing = Facing.RIGHT
					var mult = 1
					if distance > 25:
						mult = 2.5
					if facing_dir < 0: # attempt to go right or left of player
						$NavigationAgent2D.target_position = player.global_position - Vector2(10 * mult,0)
					else:
						$NavigationAgent2D.target_position = player.global_position + Vector2(10 * mult,0)
					var next_path_point = $NavigationAgent2D.get_next_path_position()
					var direction = (next_path_point - global_position).normalized()
					velocity = direction * movement_speed
					move_and_slide()
				else:
					state = State.ATTACK
					self.velocity = Vector2(0, 0)
					$NavigationAgent2D.set_velocity(Vector2.ZERO)
					$NavigationAgent2D.target_position = global_position
					
				if attacking:
					if cur_time > 2:
						animation_player.play("attack")
						skeleton_attack.play()
						cur_time = 0
					cur_time += delta
		State.ATTACK:
			set_animation("attack")
			is_attacking = true
			state = State.IDLE
		State.STUN:
			set_animation("hurt")
			atk_hitbox.monitoring = false
			is_attacking = false
			process_knockback(delta)
	super(delta)
	
func _deactivate():
	set_animation("dead")
	skeleton_death.play()
	var tween = self.create_tween()
	tween.tween_property(health_bar, "modulate:a", 0.0, 0.8).set_delay(0.1).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(_destory)

func _destory():
	#queue_free()
	print("destroy?")

func bind_skeleton_commands():
	right_cmd = MoveRightCommand.new()
	left_cmd = MoveLeftCommand.new()
	up_cmd = MoveUpCommand.new()
	down_cmd = MoveDownCommand.new()


func take_damage(damage:int):
	health -= damage
	if 0 >= health:
		_deactivate()
		atk_hitbox.monitoring = false
		_dead = true
		animation_player.play("death")
		state = State.DEAD
		velocity = Vector2.ZERO
		
	print((float(health) / float(max_health)))
	health_bar.value  = (float(health) / float(max_health)) * 100

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
	if not 0 >= health:
		state = State.CHASE
	
func chance_coin() -> void:
	var coin_spawner = coin_factory.instantiate()
	coin_spawner.spawning_pos = global_position
	add_child(coin_spawner)
	if randf_range(0, 1) < coin_drop_chance:
		coin_spawner.spawn_coins(1)



func set_animation(new_anim:StringName):
	match new_anim:
		"dead":
			animation_tree["parameters/conditions/dead"] = true
			animation_tree["parameters/conditions/idle"] = false
			animation_tree["parameters/conditions/walk"] = false
			animation_tree["parameters/conditions/attack"] = false
			animation_tree["parameters/conditions/hurt"] = false
		"idle":
			animation_tree["parameters/conditions/dead"] = false
			animation_tree["parameters/conditions/idle"] = true	
			animation_tree["parameters/conditions/walk"] = false
			animation_tree["parameters/conditions/attack"] = false
			animation_tree["parameters/conditions/hurt"] = false
		"walk":
			animation_tree["parameters/conditions/dead"] = false
			animation_tree["parameters/conditions/idle"] = false
			animation_tree["parameters/conditions/walk"] = true
			animation_tree["parameters/conditions/attack"] = false
			animation_tree["parameters/conditions/hurt"] = false
		"attack":
			animation_tree["parameters/conditions/dead"] = false
			animation_tree["parameters/conditions/idle"] = false
			animation_tree["parameters/conditions/walk"] = false
			animation_tree["parameters/conditions/attack"] = true
			animation_tree["parameters/conditions/hurt"] = false
			
		"hurt":
			animation_tree["parameters/conditions/dead"] = false
			animation_tree["parameters/conditions/idle"] = false
			animation_tree["parameters/conditions/walk"] = false
			animation_tree["parameters/conditions/attack"] = false
			animation_tree["parameters/conditions/hurt"] = true



func unset_attacking():
	is_attacking = false
#func command_callback(command_name:String) -> void:
	#if "summon" == command_name:
		#audio_player.stop()
		#audio_player["parameters/switch_to_clip"] = "yell1"
		#audio_player.play()
	#if "jump" == command_name:
		#audio_player.stop()
		#audio_player["parameters/switch_to_clip"] = "blast"
		#audio_player.play()
