class_name Boss
extends CharacterBody2D

@export var player:Player
@export var projectile_manager:ProjectileManager
@export var boss_room:CollisionShape2D


@onready var anim_play:AnimationPlayer =  $AnimationPlayer
@onready var animation_tree:AnimationTree =  $AnimationTree
@onready var nav_agent:NavigationAgent2D =  $NavigationAgent2D
@onready var _sprite:Sprite2D =  $Sprite2D
@onready var spawn_timer:Timer =  $Timer

@onready var Attack1Timer:Timer = $Attack1Timer
@onready var Attack2Timer:Timer = $Attack2Timer
@onready var Attack3Timer:Timer = $Attack3Timer
@onready var Attack4Timer:Timer = $Attack4Timer
@onready var Attack5Timer:Timer = $Attack5Timer
@onready var Attack6Timer:Timer = $Attack6Timer
@onready var health_bar:ProgressBar = $HealthBar

@onready var between_timer:Timer = $InbetweenTimer

enum State {IDLE, CHASE, ATTACK, DEAD, BOUND, SPAWNING,STG2}

var state:State = State.BOUND

var target : Character

var move_rl_input: float
var move_ud_input: float
var is_moving: bool = false
var is_attacking: bool = false
var _facing_dir
var _dead:bool = false
var _done_stage2:bool = false
var enabled: bool
var _knockback_velocity: Vector2
var cur_time = 2
var coin_drop_chance = 0.4
var coin_spawned = false
var rng:RandomNumberGenerator

var minions:Array[Vampire]

var original_spawn:Vector2 

var total_health:int = 500
var second_phase:int = 250

var health = 500

var movement_speed:int = 50
var total_time:float= 0

var cur_grid:bool = true


func _ready() -> void:
	add_to_group("Enemies")
	rng = RandomNumberGenerator.new()
	
	original_spawn = global_position # Set original pos
	enabled = true
	visible = true
	_sprite.visible = true	
	_sprite.modulate = Color(1.0, 1.0, 1.0, 0.0)
	state = State.BOUND
	pause_tree()
	animation_tree["parameters/conditions/spawn"] = false
	animation_tree["parameters/conditions/boss_sp_attack1"] = false
	animation_tree["parameters/conditions/boss_death"] = false
	animation_tree["parameters/conditions/is_walking"] = false
	animation_tree["parameters/conditions/boss_sp_attack1"] = false
	animation_tree["parameters/conditions/sp_attack2"] = false
	
func _process(delta: float) -> void:
	if not enabled:
		return 
	total_time += delta
	if total_time > 9:
		if not is_attacking:
			cur_grid = not cur_grid
			#special_attack5()
		
		#emit_random_balls()
		#SpiralCW(original_spawn + Vector2(160,0))
		#SpiralCCW(original_spawn - Vector2(160,0))
		#if cur_grid:
			#
			#HorizontalGrid1(original_spawn)
		#else:
			#HorizontalGrid2(original_spawn)
		total_time = 0

func _physics_process(delta: float) -> void:
	if player == null or projectile_manager == null:
		return 
	if not enabled :
		return

	match state:
		State.BOUND:
			var dist = (player.global_position - global_position).length()
			if dist < 200:
				spawn()
		State.CHASE:
			set_animation("walk")
			nav_agent.debug_enabled = true
			nav_agent.target_position = player.global_position 
			var next_path_point = nav_agent.get_next_path_position()
			var direction = (next_path_point - global_position).normalized()
			print(next_path_point )
			velocity = direction * movement_speed
			move_and_slide()		
			var dist = (player.global_position - global_position).length()
			
			
			
			var prob_close = 1
			var prob_far = 100
			var prob_relocate = 1
			if dist < 20:
				prob_relocate = 300
				
			if dist < 100:
				prob_close = 50
				prob_far = 30
			elif dist < 200:
				prob_close = 20
				prob_far = 40
			elif dist < 400:
				prob_close = 10
				prob_far = 80
			elif dist < 700:
				prob_close = 6
				prob_far = 150
			else: 
				prob_relocate = 100
				prob_close = 1
				prob_far = 150
			var rand_c = rng.randi_range(0, 10000)
			var rand_f = rng.randi_range(0, 10000)
			if rand_c < prob_relocate:
				relocate()
			if rand_c < prob_close:
				print("CLOSE HIT")
				var rand_close = rng.randi_range(0,1)
				if rand_close == 0:
					special_attack2()
				else:
					special_attack5()
			elif rand_f < prob_far:
				print("far HIT")
				var rand_move = rng.randi_range(0,1)
				if rand_move == 0: # will relocaste a lot
					relocate()
				else:
					var attack = rng.randi_range(0,3)
					match  attack:
						0: 
							special_attack1()
						1: 
							special_attack2()
						2: 
							special_attack3()
						3: 
							special_attack4()
					
				
					
				
				
				
				
				
func spawn():
	state = State.SPAWNING
	print("SPAWNING")
	var tween = self.create_tween()
	tween.tween_property(_sprite, "modulate:a", 1.0, 3).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	
	print("DONE")
	set_animation("spawn")
	state = State.CHASE
	start_tree()

# Shoot lazers from both sides and teleport
func special_attack1():
	# do wrap. \
	state = State.ATTACK
	is_attacking = true
	print("attack2")
	set_animation("attack2")
	SpiralCCW(player.global_position - Vector2(300,0))
	SpiralCW(player.global_position + Vector2(300,0))
	#go_invisible()
	Attack1Timer.start(8)
	Attack1Timer.timeout.connect(reset_movement)

# Shoot out balls 
func special_attack2():
	emit_random_balls()
	is_attacking = true
	state = State.ATTACK
	set_animation("attack")
	
	for i in range(1,3):
		set_animation("attack")
		emit_random_balls()
		Attack2Timer.start(1)
		await  Attack2Timer.timeout
	reset_movement()

## Shoot target lasers
func special_attack3():
	state = State.ATTACK
	is_attacking = true
	go_invisible()
	
	for i in range(1,6):
		target_player()
		Attack3Timer.start(1)
		await  Attack3Timer.timeout
	print("RESET")
	reset_movement()
	become_visible()
	global_position = original_spawn
#f

func relocate():
	state = State.ATTACK
	go_invisible()
	is_attacking = true
	between_timer.start(1)
	await  between_timer.timeout
	 
	var invalid = true
	for i in range(5):		
		var x_y = randi_range(0,1)
		var x = 0
		var y = 0
		var pn = randi_range(0,1)
		if x_y == 0:
			x = 0
			y = randi_range(50,300)
			if pn == 0:
				y = -y
		else:
			y = 0
			x = randi_range(50,300)
			if pn == 0:
				x = -x
		
		var shape = boss_room.shape as RectangleShape2D
		var size = shape.size
		var rect = Rect2(-size * 0.5, size)
		var ppos = player.global_position
		var cur_point = ppos +  Vector2( x, y)
		var local_point = boss_room.to_local(cur_point)
		
		if  rect.has_point(local_point):
			invalid = false
			global_position = cur_point
			break;
	if invalid == true:
		global_position = original_spawn
	become_visible()
	between_timer.start(1)
	await  between_timer.timeout
	reset_movement()
##grid attack
func special_attack4():
	is_attacking = true
	state = State.ATTACK
	var num_times = randi_range(2,5)
	var last = -1
	for i in range(1,num_times):
		print(i)
		var up:int = rng.randi_range(0,3)
		if up == last:
			up = (up + 1) % 4 
		match up:
			0:
				VerticalGrid1(global_position)
			1:
				VerticalGrid2(global_position)
			2:
				HorizontalGrid1(global_position)
			3:
				HorizontalGrid2(global_position)
		Attack4Timer.start(2.5)
		await  Attack4Timer.timeout
	reset_movement()
			
func special_attack5():	
	is_attacking = true
	state = State.ATTACK
	set_animation("attack3")
	
	Attack5Timer.start(4)
	await Attack5Timer.timeout
	reset_movement()
	set_animation("walk")
	
	
#func dmg_reset():



func take_damage(damage:int):
	health -= damage
	if 0 >= health:
		#_deactivate()

		_dead = true
		state = State.DEAD
		velocity = Vector2.ZERO
		set_animation("dead")
	print((float(health) / float(total_health)))
	health_bar.value  = (float(health) / float(total_health)) * 100
	
## Alternate lazers above
#func special_attack4():
		#
func reset_movement():
	state = State.CHASE
	is_attacking = false
	
func pause_tree():
	animation_tree.active = false
	anim_play.play("spawn")
	anim_play.seek(0.0, true)
	anim_play.stop()
	
func start_tree():
	animation_tree.active = true
	
func go_invisible():
	var tween = self.create_tween()
	tween.tween_property(_sprite, "modulate:a", 0, 1).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	
func become_visible():
	var tween = self.create_tween()
	tween.tween_property(_sprite, "modulate:a", 1.0, 3).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	
	

func set_animation(new_anim:StringName):
	match new_anim:
		"dead":
			animation_tree["parameters/conditions/spawn"] = false
			animation_tree["parameters/conditions/boss_sp_attack1"] = false
			animation_tree["parameters/conditions/boss_death"] = true	
			animation_tree["parameters/conditions/is_walking"] = false
			animation_tree["parameters/conditions/boss_attack"] = false
			animation_tree["parameters/conditions/sp_attack2"] = false
		"spawn":
			animation_tree["parameters/conditions/spawn"] = true	
			animation_tree["parameters/conditions/boss_sp_attack1"] = false
			animation_tree["parameters/conditions/boss_death"] = false
			animation_tree["parameters/conditions/is_walking"] = false
			animation_tree["parameters/conditions/boss_attack"] = false
			animation_tree["parameters/conditions/sp_attack2"] = false
		"idle":
			animation_tree["parameters/conditions/spawn"] = false
			animation_tree["parameters/conditions/boss_sp_attack1"] = false
			animation_tree["parameters/conditions/boss_death"] = false
			animation_tree["parameters/conditions/is_walking"] = true
			animation_tree["parameters/conditions/boss_attack"] = false
			animation_tree["parameters/conditions/sp_attack2"] = false
		"walk":
			animation_tree["parameters/conditions/spawn"] = false
			animation_tree["parameters/conditions/boss_sp_attack1"] = false
			animation_tree["parameters/conditions/boss_death"] = false
			animation_tree["parameters/conditions/is_walking"] = true
			animation_tree["parameters/conditions/boss_attack"] = false
			animation_tree["parameters/conditions/sp_attack2"] = false
		"attack":
			animation_tree["parameters/conditions/spawn"] = false
			animation_tree["parameters/conditions/boss_sp_attack1"] = false
			animation_tree["parameters/conditions/boss_death"] = false
			animation_tree["parameters/conditions/is_walking"] = false
			animation_tree["parameters/conditions/boss_attack"] = true
			animation_tree["parameters/conditions/sp_attack2"] = false
		"attack2":
			animation_tree["parameters/conditions/spawn"] = false
			animation_tree["parameters/conditions/boss_sp_attack1"] = true
			animation_tree["parameters/conditions/boss_death"] = false
			animation_tree["parameters/conditions/is_walking"] = false
			animation_tree["parameters/conditions/boss_attack"] = false
			animation_tree["parameters/conditions/sp_attack2"] = false
		"attack3":
			animation_tree["parameters/conditions/spawn"] = false
			animation_tree["parameters/conditions/boss_sp_attack1"] = false
			animation_tree["parameters/conditions/boss_death"] = false
			animation_tree["parameters/conditions/is_walking"] = false
			animation_tree["parameters/conditions/boss_attack"] = false
			animation_tree["parameters/conditions/sp_attack2"] = true
			
			
func SpiralCW(pos: Vector2):
	for i in range(10):
			#await get_tree().create_timer(0.1).timeout
			#var new_projectile = projectile.instantiate() as FireBall
			var projectile_list: Array[ProjectileInfo] = []
			var projectile_info = ProjectileInfo.new(
			CharacterSpec.spec.ENEMY, 
				10, # damage
				8, # Lifetime
				1, # Spawn delay
				0, # Speed
				0, # Accelerat ion
				i * 36, # Initial Rotation
				20 # Initial Rot velocity 
			)
			projectile_list.append(projectile_info)
			projectile_manager.spawn_laser(pos, projectile_list)

# Couunter clock
func SpiralCCW(pos: Vector2):
	for i in range(10):
			#await get_tree().create_timer(0.1).timeout
			#var new_projectile = projectile.instantiate() as FireBall
			var projectile_list: Array[ProjectileInfo] = []
			var projectile_info = ProjectileInfo.new(
			CharacterSpec.spec.ENEMY, 
				10, # damage
				8, # Lifetime
				1, # Spawn delay
				0, # Speed
				0, # Accelerat ion
				i * 36, # Initial Rotation
				-20 # Initial Rot velocity 
			)
			projectile_list.append(projectile_info)
			projectile_manager.spawn_laser(pos, projectile_list)

func VerticalGrid1(pos: Vector2):
	for i in range(-10, 10, 1):
		if (abs(i)%2 == 0):
			var top_anchor = pos + Vector2(80 * i,-1000)
			#await get_tree().create_timer(0.1).timeout
			#var new_projectile = projectile.instantiate() as FireBall
			var projectile_list: Array[ProjectileInfo] = []
			var projectile_info = ProjectileInfo.new(
			CharacterSpec.spec.ENEMY, 
				10, # damage
				2, # Lifetime
				1, # Spawn delay
				0, # Speed
				0, # Accelerat ion
				90, # Initial Rotation
				0 # Initial Rot velocity 
			)
			projectile_list.append(projectile_info)
			projectile_manager.spawn_big_laser(top_anchor, projectile_list)
func VerticalGrid2(pos: Vector2):
	for i in range(-10, 10, 1):
		if (abs(i)%2 != 0):
			print(i)
			var top_anchor = pos + Vector2(80 * i,-1000)
			#await get_tree().create_timer(0.1).timeout
			#var new_projectile = projectile.instantiate() as FireBall
			var projectile_list: Array[ProjectileInfo] = []
			var projectile_info = ProjectileInfo.new(
			CharacterSpec.spec.ENEMY, 
				10, # damage
				2, # Lifetime
				1, # Spawn delay
				0, # Speed
				0, # Accelerat ion
				90, # Initial Rotation
				0 # Initial Rot velocity 
			)
			projectile_list.append(projectile_info)
			projectile_manager.spawn_big_laser(top_anchor, projectile_list)

func HorizontalGrid1(pos: Vector2):
	for i in range(-10, 10, 1):
		if (abs(i)%2 == 0):
			var top_anchor = pos + Vector2(1000, 80 * i)
			#await get_tree().create_timer(0.1).timeout
			#var new_projectile = projectile.instantiate() as FireBall
			var projectile_list: Array[ProjectileInfo] = []
			var projectile_info = ProjectileInfo.new(
			CharacterSpec.spec.ENEMY, 
				10, # damage
				2, # Lifetime
				1, # Spawn delay
				0, # Speed
				0, # Accelerat ion
				180, # Initial Rotation
				0 # Initial Rot velocity 
			)
			projectile_list.append(projectile_info)
			projectile_manager.spawn_big_laser(top_anchor, projectile_list)
			
func HorizontalGrid2(pos: Vector2):
	for i in range(-10, 10, 1):
		if (abs(i)%2 != 0):
			print(i)
			var top_anchor = pos + Vector2(1000, 80 * i)
			#await get_tree().create_timer(0.1).timeout
			#var new_projectile = projectile.instantiate() as FireBall
			var projectile_list: Array[ProjectileInfo] = []
			var projectile_info = ProjectileInfo.new(
			CharacterSpec.spec.ENEMY, 
				10, # damage
				2, # Lifetime
				1, # Spawn delay
				0, # Speed
				0, # Accelerat ion
				180, # Initial Rotation
				0 # Initial Rot velocity 
			)
			projectile_list.append(projectile_info)
			projectile_manager.spawn_big_laser(top_anchor, projectile_list)
			
func target_player():
	var p_pos = player.global_position
	var left_root = 	p_pos + Vector2(-700 ,0 )
	var right_root = 	p_pos + Vector2(700 ,0 )

	#left
	for i in range(-1,1,1):
		var cur_root = left_root + Vector2(0, 500 * i)
		var dir = rad_to_deg( (p_pos - cur_root ).angle())
		var projectile_list: Array[ProjectileInfo] = []
		var projectile_info = ProjectileInfo.new(
		CharacterSpec.spec.ENEMY, 
			10, # damage
			1, # Lifetime
			0.3, # Spawn delay
			0, # Speed
			0, # Accelerat ion
			dir, # Initial Rotation
			0 # Initial Rot velocity 
		)
		projectile_list.append(projectile_info)
		projectile_manager.spawn_laser(cur_root, projectile_list)

	#right
	for i in range(-1,1,1):
		var cur_root = right_root + Vector2(0, 500 * i)
		var dir = rad_to_deg( (p_pos - cur_root).angle())
		var projectile_list: Array[ProjectileInfo] = []
		var projectile_info = ProjectileInfo.new(
		CharacterSpec.spec.ENEMY, 
			10, # damage
			1, # Lifetime
			0.3, # Spawn delay
			0, # Speed
			0, # Accelerat ion
			dir, # Initial Rotation
			0 # Initial Rot velocity 
		)
		projectile_list.append(projectile_info)
		projectile_manager.spawn_laser(cur_root, projectile_list)
	#
func emit_balls_spiral():
	var rand_start = rng.randi_range(0,360)
	for i in range(10):
			#var new_projectile = projectile.instantiate() as FireBall
			spawn_timer.start(0.1)
			await spawn_timer.timeout
			
			var dir_deg = rand_start - i * 36
			var projectile_list: Array[ProjectileInfo] = []
			var projectile_info = ProjectileInfo.new(
				CharacterSpec.spec.ENEMY, 
				10, # damage
				1, # Lifetime
				0.1, # Spawn delay
				120, # Speed
				70, # Acceleration
				dir_deg, # Initial Rotation
				0 # Initial Rot velocity 
				)
			projectile_list.append(projectile_info)
			var projectile_info2 = ProjectileInfo.new(
				CharacterSpec.spec.ENEMY, 
				10, # damage
				0.5, # Lifetime
				0.1, # Spawn delay
				0, # Speed
				0, # Acceleration
				dir_deg, # Initial Rotation
				0 # Initial Rot velocity 
				)
			projectile_list.append(projectile_info2)
			var projectile_info3 = ProjectileInfo.new(
				CharacterSpec.spec.ENEMY, 
				10, # damage
				1, # Lifetime
				2, # Spawn delay
				120, # Speed
				70, # Acceleration
				dir_deg + 180, # Initial Rotation
				0 # Initial Rot velocity 
				)
			projectile_list.append(projectile_info3)
			
			
			
			var new_pos = global_position + Vector2.from_angle(deg_to_rad(dir_deg)) * 10
			BUS.emit_signal("spawn_voidball", new_pos , projectile_list)

func emit_random_balls():
	for i in range(5):
			#var new_projectile = projectile.instantiate() as FireBall
		var p_pos = player.global_position
		var player_dir = rad_to_deg( (p_pos - global_position ).angle()) + 180
		var random_dir = player_dir + rng.randi_range(-140, 140)
		
		var random_speed = rng.randi_range(140, 200)
		var projectile_list:Array[ProjectileInfo] = []
		var projectile_spawn = ProjectileInfo.new(
			CharacterSpec.spec.ENEMY, 
			10, # damage
			1, # Lifetime
			0.01, # Spawn delay
			random_speed, # Speed
			-random_speed, # Acceleration
			random_dir, # Initial Rotation
			0 # Initial Rot velocity 
		)
		var projectile_shoot = ProjectileInfo.new(
			CharacterSpec.spec.ENEMY, 
			10, # damage
			7, # Lifetime
			0.01, # Spawn delay
			170, # Speed
			70, # Acceleration
			0, # Initial Rotation
			0, # Initial Rot velocity 
			player
		)
		projectile_list.append(projectile_spawn)
		projectile_list.append(projectile_shoot)
			
			
		var new_pos = global_position 
		BUS.emit_signal("spawn_voidball", new_pos , projectile_list)
