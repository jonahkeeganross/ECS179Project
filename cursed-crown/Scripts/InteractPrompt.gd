class_name InteractPrompt
extends Label

var showing: bool = false

func _ready() -> void:
	visible = false
	text = "按 F 打开商店"
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func show_prompt() -> void:
	visible = true
	showing = true

func hide_prompt() -> void:
	visible = false
	showing = false
