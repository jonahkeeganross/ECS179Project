extends Sprite2D




var tween:Tween

func _ready() -> void:
	
	var tween = self.create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(_on_tween_finished)




func _on_tween_finished() -> void:
	self.queue_free
