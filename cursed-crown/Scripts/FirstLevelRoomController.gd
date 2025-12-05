class_name RoomController
extends Node2D

@export var enemy_spawner : Node2D
@export var is_tutorial: bool


@onready var player = get_node("Player")

var doors : Array[StaticBody2D] = []
var original_position : Vector2
var enable_skeleton : bool = false
var enable_vampire : bool = false
var skeletons : Array[Skeleton]
var vampires : Array[Vampire]


func _ready() -> void:
	skeletons = enemy_spawner.skeletons
	vampires = enemy_spawner.vampires


func _process(delta) -> void:
	var current_room = player.current_area
	var current_room_enemies : Array
	
	var bodies = current_room.get_overlapping_bodies()
	for body in bodies:
		if body in get_tree().get_nodes_in_group("Enemies"):
			current_room_enemies.append(body)
			
				
	
	print(current_room_enemies)
		
	if count_enemies(current_room):
		if not is_tutorial:
			for door in get_tree().get_nodes_in_group("door"):
				door.open()
		elif is_tutorial:
			var door_dialogue = get_node("DoorDialogue")
			door_dialogue.activate = true
			
			var altars = get_tree().get_nodes_in_group("Altar")
			if altars[0].opened:
				door_dialogue.activate = false
				for door in get_tree().get_nodes_in_group("door"):
					door.open()
	else:
		for door in get_tree().get_nodes_in_group("door"):
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
			if distance > 75:
				skeleton.is_moving = true
				skeleton.attacking = false
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
				vampire.is_attacking = false
			else:
				vampire.is_moving = false
				vampire.is_attacking = true
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
	
