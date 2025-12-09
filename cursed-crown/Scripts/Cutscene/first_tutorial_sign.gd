class_name FirstTutorialSign
extends Area2D


@onready var area:Area2D = self


var dialogue:Array[String]
var _has_activated = false

var test1:String = "There seems to be a skeleton guarding the castle, use your
attacks to take it out!
"
#var test2:String = "
#Dwelling and speedily ignorant any steepest. Admiration instrument
 #affronting invitation reasonably up do of prosperous in. 
#Shy saw declared age debating ecstatic man. 
#Call in so want pure rank am dear were. 
#"
#var test3:String = "
#Remarkably to continuing in surrounded diminution on. In unfeeling existence objection 
#immediate repulsive on he in. Imprudence comparison uncommonly me he difficulty 
#diminution resolution. Likewise proposal differed scarcely dwelling as on raillery. 
#September few dependent extremity own continued and ten prevailed attending. 
#Early to weeks we could. 
#"



func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	dialogue.push_back(test1)
	#dialogue.push_back(test2)
	#dialogue.push_back(test3)
	_has_activated = false
	
	
	
func _on_body_entered(body: Node) -> void:
	if body is Player: 
		if _has_activated == false:
			BUS.emit_signal("queue_dialogue",dialogue)
			#print("ENTERED")
			_has_activated = true
	
