class_name Skeleton
extends Character

var health:int = 100
var target : Character
var cmd_list : Array[Command]

var move_rl_input: float
var move_ud_input: float
var is_moving: bool = false
var _facing_dir
var _dead:bool = false
var player = GameState.player
var enabled: bool

#@onready var audio_player:AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	add_to_group("Enemies")
	add_to_group("Skeleton")
	bind_skeleton_commands()
	movement_speed = 75


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
