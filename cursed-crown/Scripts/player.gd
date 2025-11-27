class_name Player
extends Character

@export var health: int = 100

enum FacingDir { LEFT, RIGHT, UP, DOWN }

var dash_cmd: Command
var _dead: bool = false
var _facing_dir: int = FacingDir.RIGHT
var current_area: Area2D = null


func _ready():
	add_to_group("Player")
	bind_player_input_commands()
	animation_player.process_mode = Node.PROCESS_MODE_ALWAYS
	_play_animation("idle")
	self.type = CharacterSpec.spec.PLAYER


func _physics_process(delta: float):
	if _dead:
		return

	var move_rl_input := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var move_ud_input := Input.get_action_strength("move_up") - Input.get_action_strength("move_down")

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


	
	if is_moving_h or is_moving_v:
		
		match _facing_dir:
			FacingDir.UP:
				_play_animation("walk_up")
			FacingDir.DOWN:
				_play_animation("walk_down")
			FacingDir.LEFT, FacingDir.RIGHT:
				
				_play_animation("walk")
	else:
		# Idle
		match _facing_dir:
			FacingDir.UP:
				_play_animation("idle_up")
			FacingDir.DOWN:
				_play_animation("idle_down")
			FacingDir.LEFT, FacingDir.RIGHT:
				_play_animation("idle")


	if Input.is_action_just_pressed("dash"):
		dash_cmd.execute(self)

	super(delta)


func take_damage(damage: int) -> void:
	health -= damage
	$HealthBar.value = health

	if health <= 0:
		_dead = true
		_play_animation("death")
	else:
		_play_animation("hurt")


func resurrect() -> void:
	_dead = false
	health = 100
	$HealthBar.value = health
	_play_animation("revival")


func bind_player_input_commands():
	right_cmd = MoveRightCommand.new()
	left_cmd = MoveLeftCommand.new()
	dash_cmd = DashCommand.new()
	up_cmd = MoveUpCommand.new()
	down_cmd = MoveDownCommand.new()


func _play_animation(anim_name: String) -> void:
	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)
