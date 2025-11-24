class_name TestingRoomController
extends Node2D

@export var room1 : Area2D
@export var room2 : Area2D
@export var door1 : StaticBody2D
@export var door2 : StaticBody2D
@export var skeleton : Character

@onready var player = get_node("Player")

var doors : Array[StaticBody2D] = []
var original_position


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
	
func count_enemies(room : Area2D) -> bool:
	var bodies = room.get_overlapping_bodies()
	print(get_tree().get_nodes_in_group("Enemies"))
	var total_bodies = 0
	for body in bodies:
		if body in get_tree().get_nodes_in_group("Enemies"):
			total_bodies += 1
	print(total_bodies)
	if total_bodies == 0:
		return true
	return false
	

func start_skeleton() -> void:
	original_position = skeleton.global_position
	while skeleton.health > 0:
		# Calculate which side of the player that the boss is on as well as absolute distance
		var skeleton_direction_x = skeleton.global_position.x - player.global_position.x
		var skeleton_direction_y = skeleton.global_position.y - player.global_position.y
		var distance = (skeleton.global_position - player.global_position).length()

		# Track toward the character until within range
		if distance > 100:
			if skeleton_direction_x > 0:
				skeleton.is_moving_h = true
				skeleton.move_rl_input = -1
			elif skeleton_direction_x < 0:
				skeleton.is_moving_h = true
				skeleton.move_rl_input = 1
				
			if skeleton_direction_y > 0:
				skeleton.is_moving_v = true
				skeleton.move_ud_input = 1
			elif skeleton_direction_y < 0:
				skeleton.is_moving_v = true
				skeleton.move_ud_input = -1
		elif distance < 100:
			skeleton.is_moving_h = false
			skeleton.is_moving_v = false
			
		# Attack when in range of character
	
		await get_tree().create_timer(1.0).timeout
		
	return
	
