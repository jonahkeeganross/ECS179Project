class_name Chest
extends Area2D

@export var coin_factory : PackedScene
@export var animated_sprite : AnimatedSprite2D

var player_is_inside : bool = false
var opened : bool = false

func _ready() -> void:
	add_to_group("Chest")
	

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
			open_chest()
			

func open_chest() -> void:
	animated_sprite.play("open")
	var coin_spawner = coin_factory.instantiate()
	coin_spawner.spawning_pos = global_position
	add_child(coin_spawner)
	coin_spawner.spawn_coins(randi_range(1,4))
