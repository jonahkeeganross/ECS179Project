class_name Character
extends CharacterBody2D

signal CharacterDirectionChange(facing:Facing)


enum Facing { 
	LEFT,
	RIGHT,
	UP,
	DOWN,
}

const TERMINAL_VELOCITY = 700
const DEFAULT_JUMP_VELOCITY = -400
const DEFAULT_MOVE_VELOCITY = 300

var movement_speed = DEFAULT_MOVE_VELOCITY


var right_cmd : Command
var left_cmd : Command
var up_cmd : Command
var down_cmd : Command
var attack_cmd : Command


var type:CharacterSpec.spec
var facing:Facing = Facing.RIGHT
var attacking : bool: 
	set(value): 
		attacking = value
	get():
		return attacking

var summoning : bool:
	set(value):
		summoning = value
	get():
		return summoning

var jumping:bool = false
var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
var original_hb_pos: int
var collision_shape: CollisionShape2D

var _horizontal_input : float


@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sprite:Sprite2D = $Sprite2D
#@onready var dialogue_box:DialogueBox = %DialogueBox



func _ready() -> void:
	attacking = false
	summoning = false

	
	#change_facing(facing)


func move(value: float) -> void:
	_horizontal_input = value

#
#func change_facing(new_facing:Facing) -> void:
	#facing = new_facing
	#emit_signal("CharacterDirectionChange", facing)


#This function is meant to be called in the AnimationController after the each relevant anmiation has concluded.
func clear_action_state() -> void:
	attacking = false
	summoning = false

func command_callback(_name:String) -> void:
	pass


func _physics_process(delta: float) -> void: 
	#_apply_gravity(delta)
	_apply_movement(delta)


func _apply_movement(_delta: float):
	move_and_slide()


#func _apply_gravity(delta : float) -> void:
	#
	#velocity.y = minf(TERMINAL_VELOCITY, velocity.y + gravity * delta)
