class_name Player
extends Character

@export var health: int = 100

enum Direction { LEFT, RIGHT }

var dash_cmd: Command
var _dead: bool = false
var _facing_dir: int = Direction.RIGHT


func _ready():
	bind_player_input_commands()
	_play_animation("idle")


func _physics_process(delta: float):
	if _dead:
		return

	var move_rl_input := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var move_ud_input := Input.get_action_strength("move_up") - Input.get_action_strength("move_down")

	var is_moving_h: bool = abs(move_rl_input) > 0.1
	var is_moving_v: bool = abs(move_ud_input) > 0.1

	
	if is_moving_h:
		if move_rl_input > 0:
			_facing_dir = Direction.RIGHT
			sprite.flip_h = false
			right_cmd.execute(self)
		else:
			_facing_dir = Direction.LEFT
			sprite.flip_h = true
			left_cmd.execute(self)

		_play_animation("walk")
	else:
		self.velocity.x = 0


	if is_moving_v:
		if move_ud_input > 0:
			up_cmd.execute(self)
		else:
			down_cmd.execute(self)

		# keep walking animation even when moving vertically
		_play_animation("walk")

	else:
		self.velocity.y = 0

	# idle when still
	if not is_moving_h and not is_moving_v:
		_play_animation("idle")

	# dash
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
