class_name Room
extends Area2D

@export var room_name: String = "null"


func _ready():
	room_name = name
	connect("body_entered", Callable(self, "_on_body_entered"))


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.current_area = self
		print("Player entered:", room_name)


#func _on_body_exited(body):
	#if body.is_in_group("Player"):
		#if body.current_area == self:
			#body.current_area = null
			#print("Player left:", room_name)
