extends Node2D


@onready var crown: Sprite2D = $crown

func _ready() -> void:
	
	crown.modulate.a = 0.0

	
	var tween = create_tween()
	tween.tween_property(crown, "modulate:a", 1.0, 0.8)  # fade in
	tween.tween_interval(3.0)
	tween.tween_callback(Callable(self, "_on_done"))
	

func _on_done() -> void:
	get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")
