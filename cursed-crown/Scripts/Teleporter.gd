class_name Teleporter
extends Area2D

func _ready():
	add_to_group("teleorter")


func _on_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file("res://Scenes/MainFloor.tscn")
