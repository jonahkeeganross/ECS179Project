extends Control

@export var next_scene: PackedScene

func _ready() -> void:
	set_process_unhandled_input(true)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		_go_to_next_scene()

	if event is InputEventMouseButton and event.pressed:
		_go_to_next_scene()


func _go_to_next_scene() -> void:
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)
