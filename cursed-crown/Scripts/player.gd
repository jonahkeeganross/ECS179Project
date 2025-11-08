class_name Player
extends Character 

@export var health:int = 100
enum Direction {
	LEFT,
	RIGHT
}

var dash_cmd:Command
var _damaged:bool = false
var _dead:bool = false
var _last_pressed:int = Direction.RIGHT

@onready var animation_tree:AnimationTree = $AnimationTree





func _ready():
	
	animation_tree.active = true
	bind_player_input_commands()
	command_callback("undeath")



func _physics_process(delta: float):
	if _dead:
		return

	var move_rl_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var move_ud_input = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	#Stage1 - handle jump input and commands here.


	
	if move_rl_input > 0.1:
		right_cmd.execute(self)
	elif move_rl_input < -0.1:
		left_cmd.execute(self)
	else	:
		self.velocity.x = 0
	if move_ud_input > 0.1:
		up_cmd.execute(self)
	elif move_ud_input < -0.1:
		down_cmd.execute(self)
	else:
		self.velocity.y = 0
	if Input.is_action_just_pressed("dash"):
		dash_cmd.execute(self)
	
	super(delta)
	
	_manage_animation_tree_state()


func take_damage(damage:int) -> void:
	health -= damage
	$HealthBar.value = health # Updates Health bar
	_damaged = true
	if 0 >= health:
		_play($Audio/defeat)
		_dead = true
		animation_tree.active = false
		animation_player.play("death")
	else:
		_play($Audio/hurt)


func bind_player_input_commands():
	right_cmd = MoveRightCommand.new()
	left_cmd = MoveLeftCommand.new()
	dash_cmd = DashCommand.new()
	up_cmd = MoveUpCommand.new()
	down_cmd = MoveDownCommand.new()


func unbind_player_input_commands():
	print("UNbound bby")
	#right_cmd = IdleCommand.new()
	#left_cmd = IdleCommand.new()
	##dash = IdleCommand.new()
	#up_cmd = IdleCommand.new()
	#jump_cmd = IdleCommand.new()


func resurrect() -> void:
	_dead = false
	health = 100
	$HealthBar.value = health # Updates Health bar
	


func command_callback(cmd_name:String) -> void:
	if "attack" == cmd_name:
		print("ATTACK AUDIO")
	

#Logic to support the state machine in the AnimationTree
func _manage_animation_tree_state() -> void:
	health = 100
	#print("KK")

func _play(player:AudioStreamPlayer2D) -> void:
	if !player.playing:
		player.play()
