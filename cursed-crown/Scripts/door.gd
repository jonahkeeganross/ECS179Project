extends StaticBody2D


func open() -> void:
	$Door_Open.visible = true
	$Door_Closed.visible = false
	$CollisionShape2D.disabled = true
	
	
func closed() -> void:
	$Door_Open.visible = false
	$Door_Closed.visible = true
	$CollisionShape2D.disabled = false
	
