class_name Altar
extends Area2D

var opened: bool = false
var player_is_inside: bool = false


func _ready() -> void:
	add_to_group("Altar")
	

func _on_body_entered(body) -> void:
	if body in get_tree().get_nodes_in_group("Player"):
		player_is_inside = true
		
		
func _on_body_exited(body) -> void:
	if body in get_tree().get_nodes_in_group("Player"):
		player_is_inside = false
	
		
func _process(delta) -> void:
	if player_is_inside:
		if Input.is_action_just_pressed("interact"):
			opened = true
