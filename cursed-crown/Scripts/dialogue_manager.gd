class_name DialogueController
extends Control


#
#@onready var arrow_next:TextureRect = $Panel2/Background/MarginContainer/Panel/ArrowNext
#@onready var test:ProgressBar = $
##
#
#var pos:Vector2
#var time_elapsed:float = 0
#var arrow 
#
#func  _ready() -> void:
	#pos = arrow_next.position
	#print("ready")
#
#
#func _process(delta: float) -> void:
	#time_elapsed += delta
	#arrow_next.position.y = pos.y + sin(time_elapsed)
#
#
#
#func display_dialogue(txt: String):
	#print("making dialogue")
