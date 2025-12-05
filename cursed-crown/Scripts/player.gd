class_name Player
extends Character

@export var health: int = 100

@export var arrow_scene: PackedScene


@onready var animation_tree:AnimationTree  = $AnimationTree
@onready var invincibility_timer:Timer = $InvincibilityTimer
@onready var blink_timer:Timer = $BlinkTimer

enum ActionState {IDLE, ATTACK, DASH}
enum FacingDir { LEFT, RIGHT, UP, DOWN }

var dash_cmd: Command
var direction: Vector2 = Vector2.ZERO
var _dead: bool = false
var _facing_dir: int = FacingDir.RIGHT
var current_area: Area2D = null

const max_stamina = 100
var stamina:float = 100

var state:ActionState = ActionState.IDLE
var time_since_stamina_use:float = 0
var time_to_stam_regen:float = 1
var stam_regen_rate_base:float = 5
var cur_stam_regen_rate:float = 2
var acceleration:float = 8

var cur_anim:String = ""

var ghost_scene = preload("res://Scenes/DashGhost.tscn")

var iframe_length = 1
var invincible = false
var pi: PlayerInfo


func _ready():
	pi = PlayerInfo.new(self)
	
	#animation_player.animation_finished.connect(_on_animation_finished)
	
	GameState.player = self
	add_to_group("Player")
	bind_player_input_commands()
	animation_player.process_mode = Node.PROCESS_MODE_ALWAYS
	_play_animation("idle")
	invincibility_timer.timeout.connect(_on_invincibility_timeout)
	self.type = CharacterSpec.spec.PLAYER
	blink_timer.timeout.connect(_on_blink_timeout)
	
func _process(delta: float) -> void:
	time_since_stamina_use += delta
	
	if stamina < max_stamina and time_since_stamina_use > time_to_stam_regen:
		cur_stam_regen_rate += acceleration * delta
		stamina += cur_stam_regen_rate * delta
		set_stamina(stamina)



func _physics_process(delta: float):
	if _dead:
		return
	if Input.get_vector("move_left", "move_right", "move_up", "move_down") != Vector2.ZERO:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	var move_rl_input := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var move_ud_input := Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	
	var attack_pressed := Input.is_action_just_pressed("attack")
	
	
	var is_moving_h: bool = abs(move_rl_input) > 0.1
	var is_moving_v: bool = abs(move_ud_input) > 0.1
	var is_diagonal: bool = is_moving_h and is_moving_v

	
	if is_moving_h:
		if move_rl_input > 0.0:
			_facing_dir = FacingDir.RIGHT
			sprite.flip_h = false
			right_cmd.execute(self)
		else:
			_facing_dir = FacingDir.LEFT
			sprite.flip_h = true
			left_cmd.execute(self)
	else:
		self.velocity.x = 0.0


	if is_moving_v:
		if not is_diagonal:
			if move_ud_input > 0.0:
				_facing_dir = FacingDir.UP
			else:
				_facing_dir = FacingDir.DOWN

		if move_ud_input > 0.0:
			up_cmd.execute(self)
		else:
			down_cmd.execute(self)
	else:
		self.velocity.y = 0.0

	update_animation_parameters()
	
	if Input.is_action_just_pressed("dash"):
		dash_cmd.execute(self)
		stamina -= 10
		set_stamina(stamina)
		time_since_stamina_use  = 0 
		cur_stam_regen_rate = stam_regen_rate_base
		dash_cmd.execute(self)
		create_ghost()
	super(delta)
	


func give_invincibility(duration: float = 0.5):
	invincible = true
	invincibility_timer.start(duration)
	

func  _on_blink_timeout():
	sprite.visible = !sprite.visible
	if invincibility_timer.time_left < 0.2:
		blink_timer.start(0.03)
	elif invincibility_timer.time_left < 0.5:
		blink_timer.start(0.06)
	

func _on_invincibility_timeout():
	invincible = false
	blink_timer.stop()
	sprite.visible = true

func take_damage(damage: int) -> void:
	if not invincible:
		blink_timer.start(0.08)
		give_invincibility(1)
		health -= damage
		set_health(health)
		$HealthBar.value = health
		
		if health <= 0:
			_dead = true
			#_play_animation("death")
		#else:
			#_play_animation("hurt")


func resurrect() -> void:
	_dead = false
	health = 100
	$HealthBar.value = health
	#_play_animation("revival")


func bind_player_input_commands():
	right_cmd = MoveRightCommand.new()
	left_cmd = MoveLeftCommand.new()
	dash_cmd = DashCommand.new()
	up_cmd = MoveUpCommand.new()
	down_cmd = MoveDownCommand.new()

func update_animation_parameters():
	#print("TEST")
	animation_tree.active = true
	#if is_instance_valid(animation_tree):
		#print("VALID TREE")
	if velocity == Vector2.ZERO:	
		#print("SHould be idle")
		animation_tree["parameters/conditions/idle"] = true	
		animation_tree["parameters/conditions/walk"] = false	
		
	else:
		animation_tree["parameters/conditions/idle"] = false	
		animation_tree["parameters/conditions/walk"] = true	
	#print(direction)
	if (Input.is_action_just_pressed("attack")):
		start_attack("attack")
	elif (Input.is_action_just_pressed("attack2") ):
		start_attack("attack2")
	elif (Input.is_action_just_pressed("attack3") ):
		start_attack("attack3")

	
		
	animation_tree["parameters/Idle/blend_position"] = direction
	animation_tree["parameters/Attack/blend_position"] = direction
	animation_tree["parameters/Walk/blend_position"] = direction
	animation_tree["parameters/Attack2/blend_position"] = direction
	animation_tree["parameters/Attack3/blend_position"] = direction

func _play_animation(anim_name: String) -> void:
	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)

func set_stamina(new_stamina: float):
	BUS.player_stamina_changed.emit(stamina)
	
func set_health(new_health: float):
	BUS.player_health_changed.emit(health)
	
func create_ghost():
	var ghost:Sprite2D = ghost_scene.instantiate()
	self.get_parent().add_child(ghost)

	ghost.global_position = global_position
	ghost.scale = sprite.scale
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.texture = sprite.texture

func start_attack(anim_name: String):
	if state != ActionState.IDLE:
		return	
	state = ActionState.ATTACK
	
	
	match  anim_name:
		"attack":
			if stamina - pi.attack_stamina_cons < 0:
				state = ActionState.IDLE
				return
			stamina -= pi.attack_stamina_cons
			animation_tree["parameters/conditions/attack"] = true	
			animation_tree["parameters/conditions/attack2"] = false
			animation_tree["parameters/conditions/attack3"] = false	
		"attack2":
			if stamina - pi.smash_stamina_cons < 0:
				state = ActionState.IDLE
				return
			stamina -= pi.smash_stamina_cons
			animation_tree["parameters/conditions/attack"] = false	
			animation_tree["parameters/conditions/attack2"] = true
			animation_tree["parameters/conditions/attack3"] = false	
		"attack3":
			if stamina - pi.smash_stamina_cons < 0:
				state = ActionState.IDLE
				return
			stamina -= pi.arrow_stamina_cons
			animation_tree["parameters/conditions/attack"] = false	
			animation_tree["parameters/conditions/attack2"] = false
			animation_tree["parameters/conditions/attack3"] = true	
	cur_anim = anim_name
	time_since_stamina_use = 0
	set_stamina(stamina)
func attack_animation_end():
	#print("done")
	if state == ActionState.ATTACK  :
		state = ActionState.IDLE
		animation_tree["parameters/conditions/attack"] = false	
		animation_tree["parameters/conditions/attack2"] = false	
		animation_tree["parameters/conditions/attack3"] = false	
	

func _shoot_arrow() -> void:
	if arrow_scene == null:
		print("No arrow_scene assigned!")
		return

	var arrow := arrow_scene.instantiate()

	var shoot_dir := _get_cardinal_direction()
	arrow.direction = shoot_dir

	# rotate arrow to face direction
	arrow.rotation = shoot_dir.angle()

	var spawn_offset := Vector2.ZERO
	if shoot_dir == Vector2.RIGHT:
		spawn_offset = Vector2(8, -2)
	elif shoot_dir == Vector2.LEFT:
		spawn_offset = Vector2(-8, -2)
	elif shoot_dir == Vector2.UP:
		spawn_offset = Vector2(0, -8)
	elif shoot_dir == Vector2.DOWN:
		spawn_offset = Vector2(0, 4)

	arrow.global_position = global_position + spawn_offset

	get_parent().add_child(arrow)

	
func _get_cardinal_direction() -> Vector2:
	# If there's no movement, fall back to facing dir
	if direction == Vector2.ZERO:
		match _facing_dir:
			FacingDir.UP:
				return Vector2.UP
			FacingDir.DOWN:
				return Vector2.DOWN
			FacingDir.LEFT:
				return Vector2.LEFT
			FacingDir.RIGHT:
				return Vector2.RIGHT

	var d := direction.normalized()

	# whether vertical or horizontal is dominating
	if abs(d.y) >= abs(d.x):
		# Vertical dominates
		if d.y < 0.0:
			return Vector2.UP
		else:
			return Vector2.DOWN
	else:
		# Horizontal dominates
		if d.x > 0.0:
			return Vector2.RIGHT
		else:
			return Vector2.LEFT
