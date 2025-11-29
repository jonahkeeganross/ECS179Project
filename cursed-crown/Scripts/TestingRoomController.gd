class_name TestingRoomController
extends Node2D

@export var room1 : Area2D
@export var room2 : Area2D
@export var door1 : StaticBody2D
@export var door2 : StaticBody2D
@export var skeleton : Character
@export var vampire : Character

@onready var player = get_node("Player")

var doors : Array[StaticBody2D] = []
var original_position
var enable_skeleton : bool = false
var enable_vampire : bool = false


func _ready() -> void:
	doors = [door1, door2]


func _process(delta) -> void:
	var current_room = player.current_area
	
	print(current_room)
	
	if count_enemies(current_room):
		for door in doors:
			door.open()
	else:
		for door in doors:
			door.closed()
			start_skeleton()
			start_vampire()
			

func _physics_process(delta: float) -> void:
	if enable_skeleton:
		var distance = (skeleton.global_position - player.global_position).length()

		# Track toward the character until within range and do physical attack
		if distance > 50:
			skeleton.is_moving = true
		else:
			skeleton.is_moving = false
			skeleton.attacking = true
	
	if enable_vampire:
		var distance = (skeleton.global_position - player.global_position).length()

		# Track toward the character until within range and do ranged attack
		if distance > 125:
			vampire.is_moving = true
		else:
			vampire.is_moving = false
			vampire.attacking = true

	
func count_enemies(room : Area2D) -> bool:
	var bodies = room.get_overlapping_bodies()
	var total_bodies = 0
	for body in bodies:
		if body in get_tree().get_nodes_in_group("Enemies"):
			total_bodies += 1
	print(total_bodies)
	if total_bodies == 0:
		return true
	return false
	

func start_skeleton() -> void:
	enable_skeleton = true
	
func start_vampire() -> void:
	enable_vampire = true
	
	
