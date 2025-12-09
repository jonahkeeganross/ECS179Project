class_name DoorDialogue
extends Area2D


@onready var area:Area2D = self

var activate : bool = false
var dialogue:Array[String]

var test1:String = "
You: I should probably check out this altar, the door might open after
"
#var test2:String = "
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
	
	
func _process(delta: float) -> void:
	if activate == false:
		$CollisionShape2D.disabled = true
	elif activate == true:
		$CollisionShape2D.disabled = false
	
	
func _on_body_entered(body: Node) -> void:
	if body is Player: 
		BUS.emit_signal("queue_dialogue",dialogue)
		#print("ENTERED")
	
