extends Node2D

@export var room1 : Area2D
@export var room2 : Area2D
@export var door1 : StaticBody2D
@export var door2 : StaticBody2D

@onready var player = get_node("Player")

var doors : Array[StaticBody2D] = []


func _ready() -> void:
	doors = [door1, door2]


func _process(delta) -> void:
	var current_room = player.current_area
	
	print(current_room)
	
	if count_enemies(current_room):
		for door in doors:
			door.open()
	else:
		for door in doors:
			door.closed()
	
	
func count_enemies(room : Area2D) -> bool:
	var bodies = room.get_overlapping_bodies()
	var total_bodies = 0
	for body in bodies:
		if body in get_tree().get_nodes_in_group("Enemies"):
			total_bodies += 1
	print(total_bodies)
	if total_bodies == 0:
		return true
	return false
	
