class_name SecondTutorialSign
extends Area2D

@onready var area: Area2D = self
@onready var tutorial_popup: TutorialPopup = null

var _has_activated: bool = false


func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	tutorial_popup = get_tree().get_first_node_in_group("TutorialPopup") as TutorialPopup
	_has_activated = false


func _on_body_entered(body: Node) -> void:
	if body is Player and not _has_activated:
		if tutorial_popup:
			# show the 3 attack tutorial PNGs in order:
			# J screen -> K screen -> L screen
			tutorial_popup.show_attack_tutorials()
		_has_activated = true
