class_name EnemySpawner
extends Node2D

@export var skeleton_scene : PackedScene
@export var vampire_scene : PackedScene
#@export var skeleton_spawn_points : Array[Vector2]
#@export var vampire_spawn_points : Array[Vector2]

var skeleton_spawn_points : Array[Vector2] = []
var vampire_spawn_points : Array[Vector2] = []
var skeletons : Array[Skeleton]
var vampires : Array[Vampire]


func _ready():
	for spawn_point in get_tree().get_nodes_in_group("skeleton_spawn_point"):
		skeleton_spawn_points.append(spawn_point.global_position)
	for spawn_point in get_tree().get_nodes_in_group("vampire_spawn_point"):
		vampire_spawn_points.append(spawn_point.global_position)
	for point in skeleton_spawn_points:
		spawn_skeleton(point)
	for point in vampire_spawn_points:
		spawn_vampire(point)


func spawn_skeleton(pos: Vector2):
	var enemy = skeleton_scene.instantiate()
	enemy.global_position = pos
	add_child(enemy)
	skeletons.append(enemy)


func spawn_vampire(pos: Vector2):
	var enemy = vampire_scene.instantiate()
	enemy.global_position = pos
	add_child(enemy)
	vampires.append(enemy)
