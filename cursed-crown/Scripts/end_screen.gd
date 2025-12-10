extends Control

@export var start_screen_scene: PackedScene
@export var delay_before_fade: float = 3.0
@export var fade_duration: float = 1.5

@onready var fade_rect: ColorRect = $FadeRect

func _ready() -> void:
	fade_rect.modulate.a = 0.0
	_run_sequence()


func _run_sequence() -> void:
	await get_tree().create_timer(delay_before_fade).timeout

	var tween := create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, fade_duration)
	await tween.finished

	_go_to_start_screen()


func _go_to_start_screen() -> void:
	if start_screen_scene:
		get_tree().change_scene_to_packed(start_screen_scene)
	else:
		get_tree().change_scene_to_file("res://path/to/StartScreen.tscn")
