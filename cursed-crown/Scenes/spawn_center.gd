class_name MinionSpawner
extends Marker2D

@export var vampire:PackedScene

var minions:Array[Vampire]
var cleared = false
var num_alive = 4

func _ready() -> void:
	set_physics_process(false)


func create_minions():
	for i in range(4):
		var cur_vamp = vampire.instantiate() as Vampire
		add_child(cur_vamp)
		cur_vamp.is_minion = true
		minions.append(cur_vamp)
		var pos = Vector2.ZERO
		match i:
			0:
				pos = global_position + Vector2(300, 300)
			1:
				pos = global_position + Vector2(300, -300)
			2:
				pos = global_position + Vector2(-300, 300)
			3:
				pos = global_position + Vector2(-300, -300)
		cur_vamp.global_position = pos
		cur_vamp.died.connect(on_minion_died)

		


func on_minion_died(minion:Vampire) ->void:
	print("here")
	minions.erase(minion)
	num_alive -= 1
	if num_alive == 0:
		cleared = true
func _all_enemies_clear() -> bool:
		return cleared
