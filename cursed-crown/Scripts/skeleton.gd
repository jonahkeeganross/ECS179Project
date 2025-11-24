class_name Skeleton
extends Character

var health:int = 100
var target : Character
var cmd_list : Array[Command]

var move_rl_input: float
var move_ud_input: float
var is_moving_h: bool
var is_moving_v: bool
var _facing_dir

var _dead:bool = false

#@onready var audio_player:AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	add_to_group("Enemies")
	bind_skeleton_commands()
	movement_speed = 100


func _process(_delta):
	if _dead:
		if !animation_player.is_playing():
			sprite.visible = false
		return
	if Facing.LEFT == facing:
		scale.y = 1.0
		rotation_degrees = 0.0
	elif Facing.RIGHT == facing:
		scale.y = -1.0
		rotation_degrees = 180.0
		
	#if len(cmd_list)>0:
		#var command_status:Command.Status = cmd_list.front().execute(self)
		##if command_status == Command.Status.ACTIVE:
		#if Command.Status.DONE == command_status:
			#cmd_list.pop_front()
	#else:
		#animation_player.play("idle")


func _physics_process(delta: float):
	if _dead:
		return
	
	if is_moving_h:
		if move_rl_input > 0:
			#_facing_dir = Direction.RIGHT
			sprite.flip_h = false
			right_cmd.execute(self)
		else:
			#_facing_dir = Direction.LEFT
			sprite.flip_h = true
			left_cmd.execute(self)

		#_play_animation("walk")
	else:
		self.velocity.x = 0


	if is_moving_v:
		if move_ud_input > 0:
			up_cmd.execute(self)
		else:
			down_cmd.execute(self)

		# keep walking animation even when moving vertically
		#_play_animation("walk")

	else:
		self.velocity.y = 0

	# idle when still
	#if not is_moving_h and not is_movings_v:
		#_play_animation("idle")

	super(delta)


func bind_skeleton_commands():
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


#func command_callback(command_name:String) -> void:
	#if "summon" == command_name:
		#audio_player.stop()
		#audio_player["parameters/switch_to_clip"] = "yell1"
		#audio_player.play()
	#if "jump" == command_name:
		#audio_player.stop()
		#audio_player["parameters/switch_to_clip"] = "blast"
		#audio_player.play()
