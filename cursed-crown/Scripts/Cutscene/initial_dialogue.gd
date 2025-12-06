class_name InitialDialogue
extends Area2D

@onready var area: Area2D = self

func _ready() -> void:
	#initial dialogue disabled
	monitoring = false
	set_deferred("monitoring", false)
	print("InitialDialogue: disabled (no intro dialogue)")
