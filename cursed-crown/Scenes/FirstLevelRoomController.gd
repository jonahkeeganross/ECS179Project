class_name FirstLevelRoomController
extends Node2D

@export var spawn : Area2D
@export var boss_room : Area2D
@export var chest_room_right : Area2D
@export var third_room_right : Area2D
@export var second_room_right : Area2D
@export var first_room_right : Area2D
@export var chest_room_left : Area2D
@export var chest_room_left_2 : Area2D
@export var last_room_left : Area2D
@export var first_room_left : Area2D
@export var door1 : StaticBody2D
@export var door2 : StaticBody2D
@export var door3 : StaticBody2D
@export var door4 : StaticBody2D
@export var door5 : StaticBody2D
@export var door6 : StaticBody2D
@export var door7 : StaticBody2D
@export var door8 : StaticBody2D
@export var door9 : StaticBody2D
@export var door10 : StaticBody2D
@export var door11 : StaticBody2D
@export var door12 : StaticBody2D
@export var door13 : StaticBody2D
@export var doorV : StaticBody2D
@export var doorV2 : StaticBody2D
@export var doorV3 : StaticBody2D
@export var doorV4 : StaticBody2D
@export var door_right : StaticBody2D
@export var door_right2 : StaticBody2D

@export var enemy_spawner : Node2D

@onready var player = get_node("Player")

var doors : Array[StaticBody2D] = []
var original_position
var enable_skeleton : bool = false
var enable_vampire : bool = false
var skeletons : Array[Skeleton]
var vampires : Array[Vampire]


func _ready() -> void:
	doors = [door1, door2, door3, door4, door5, door6, door7, door8, door9, door10,
		door11, door12, door13, doorV, doorV2, doorV3, doorV4, door_right, door_right2]
	skeletons = enemy_spawner.skeletons
	vampires = enemy_spawner.vampires


func _process(delta) -> void:
	var current_room = player.current_area
	var current_room_enemies : Array
	
	var bodies = current_room.get_overlapping_bodies()
	for body in bodies:
		if body in get_tree().get_nodes_in_group("Enemies"):
			current_room_enemies.append(body)
	
	#print(current_room)
	
	if count_enemies(current_room):
		for door in doors:
			door.open()
	else:
		#print("Cur room enemies", current_room_enemies)
		for door in doors:
			door.closed()
		for body in current_room_enemies:
			if body in get_tree().get_nodes_in_group("Skeleton"):
				body.enabled = true
			elif body in get_tree().get_nodes_in_group("Vampire"):
				body.enabled = true
			

func _physics_process(delta: float) -> void:
	for skeleton in skeletons:
		if skeleton.enabled == true:
			var distance = (skeleton.global_position - player.global_position).length()

			# Track toward the character until within range and do physical attack
			if distance > 50:
				skeleton.is_moving = true
			else:
				skeleton.is_moving = false
				skeleton.attacking = true
				# skeleton attack goes here
	
	for vampire in vampires:
		if vampire.enabled == true:
			var distance = (vampire.global_position - player.global_position).length()

			# Track toward the character until within range and do ranged attack
			if distance > 125:
				vampire.is_moving = true
			else:
				vampire.is_moving = false
				vampire.attacking = true
				# vampire attack goes here

	
func count_enemies(room : Area2D) -> bool:
	var bodies = room.get_overlapping_bodies()
	var total_bodies = 0
	for body in bodies:
		if body in get_tree().get_nodes_in_group("Enemies"):
			total_bodies += 1
	#print(total_bodies)
	if total_bodies == 0:
		return true
	return false
	

func start_skeleton() -> void:
	enable_skeleton = true
	
func start_vampire() -> void:
	enable_vampire = true
	
	
