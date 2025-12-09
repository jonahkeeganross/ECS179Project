class_name CoinFactory
extends Node2D


@export var coin : PackedScene

var spawning_pos : Vector2
var animations = [
	"spawn_1",
	"spawn_2",
	"spawn_3",
	"spawn_4"
]
var next_animations


func spawn_coins(num: int) -> void:
	shuffle_animations()
	for i in range(num):
		var new_coin = coin.instantiate()
		new_coin.global_position = spawning_pos
		#print(next_animations)
		new_coin.get_node("AnimationPlayer").play(next_animations[i])
		add_child(new_coin)


func shuffle_animations() -> void:
	next_animations = animations.duplicate()
	next_animations.shuffle()
