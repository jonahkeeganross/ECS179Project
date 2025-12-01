class_name EnemySpawner
extends Node2D

@export var skeleton_scene : PackedScene
@export var vampire_scene : PackedScene
@export var skeleton_spawn_points : Array[Vector2]
@export var vampire_spawn_points : Array[Vector2]

var skeletons : Array[Skeleton]
var vampires : Array[Vampire]


func _ready():
	for point in skeleton_spawn_points:
		spawn_skeleton(point)
	for point in vampire_spawn_points:
		print("WHATEVERS")
		#spawn_vampire(point)


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
