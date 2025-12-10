class_name RoomController
extends Node2D

@export var enemy_spawner : Node2D
@export var is_tutorial: bool

@onready var player = get_node("Player")
@onready var tutorial_popup: TutorialPopup = null
@onready var boss:Boss = %Boss



var doors : Array[StaticBody2D] = []
var original_position : Vector2
var enable_skeleton : bool = false
var enable_vampire : bool = false
var skeletons : Array[Skeleton]
var vampires : Array[Vampire]


func _ready() -> void:
	
	tutorial_popup = get_tree().get_first_node_in_group("TutorialPopup") as TutorialPopup
	if boss: 
		boss.player = $Player
		boss.projectile_manager = %ProjectileManager
		boss.boss_room = %bosscollisionshape
	
	if is_tutorial and tutorial_popup:
		_show_move_tutorial_delayed()


func _show_move_tutorial_delayed() -> void:
	await get_tree().create_timer(0.3).timeout
	if tutorial_popup:
		tutorial_popup.show_move_tutorial()


func _process(delta) -> void:
	var current_room = player.current_area
	var current_room_enemies : Array

	var bodies = current_room.get_overlapping_bodies()
	for body in bodies:
		if body in get_tree().get_nodes_in_group("Enemies"):
			current_room_enemies.append(body)

	if count_enemies(current_room):
		if not is_tutorial:
			for door in get_tree().get_nodes_in_group("door"):
				door.open()
		else:
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
			#print(current_room_enemies)
			if body in get_tree().get_nodes_in_group("Skeleton"):
				if body is Skeleton:
					#print("skeleton enabled")
					body.enabled = true
					body.set_physics_process(true)
					body.set_process(true)
					
			elif body in get_tree().get_nodes_in_group("Vampire"):
				if body is Vampire:
					body.enabled = true
					body.set_physics_process(true)
					body.set_process(true)
	#print(current_room_enemies.size())
	#print(get_tree().get_nodes_in_group("Skeleton").size())

func _physics_process(delta: float) -> void:
	skeletons = enemy_spawner.skeletons
	vampires = enemy_spawner.vampires
	#print(skeletons.size())
	for skeleton in skeletons:
		if not is_instance_valid(skeleton):
			#print("COTN")
			continue
		if skeleton.enabled == true:
			var distance = (skeleton.global_position - player.global_position).length()
#
			#if distance > 25:
				#skeleton.is_moving = true
				#skeleton.attacking = false
			#else:
				#skeleton.is_moving = false
				#skeleton.attacking = true

	for vampire in vampires:
		if not is_instance_valid(vampire):
			continue
		if vampire.enabled == true:
			var distance = (vampire.global_position - player.global_position).length()

			#if distance > 125:
				#vampire.is_moving = true
				#vampire.is_attacking = false
			#else:
				#vampire.is_moving = false
				#vampire.is_attacking = true
#


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
