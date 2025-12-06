class_name TutorialPopup
extends Control

@export var move_tutorial: Texture2D
@export var attack_j_tutorial: Texture2D
@export var attack_k_tutorial: Texture2D
@export var attack_l_tutorial: Texture2D
@export var altar_tutorial: Texture2D

@onready var image_rect: TextureRect = $Background/CenterContainer/ImageRect

var _queue = []
var _open: bool = false

func _ready() -> void:
	visible = false
	add_to_group("TutorialPopup")
	set_process_unhandled_input(true)

	
	if image_rect:
		image_rect.visible = true
		image_rect.modulate = Color(1, 1, 1, 1)
		
		if image_rect.size == Vector2.ZERO:
			var vp_size := get_viewport().get_visible_rect().size
			image_rect.custom_minimum_size = vp_size * 0.7

	print("TutorialPopup ready")
	print("  image_rect =", image_rect)
	print("  move_tutorial =", move_tutorial)
	print("  attack_j_tutorial =", attack_j_tutorial)
	print("  attack_k_tutorial =", attack_k_tutorial)
	print("  attack_l_tutorial =", attack_l_tutorial)
	print("  altar_tutorial =", altar_tutorial)


func show_move_tutorial() -> void:
	print("show_move_tutorial called")
	show_screens([move_tutorial])


func show_attack_tutorials() -> void:
	print("show_attack_tutorials called")
	show_screens([attack_j_tutorial, attack_k_tutorial, attack_l_tutorial])


func show_altar_tutorial() -> void:
	print("show_altar_tutorial called")
	show_screens([altar_tutorial])


func show_screens(textures: Array) -> void:
	if textures.is_empty():
		print("show_screens called with EMPTY array!")
		return

	var valid_textures = []
	for t in textures:
		if t != null:
			valid_textures.append(t)

	if valid_textures.is_empty():
		print("show_screens: all textures in array are NULL – did you assign them in the Inspector?")
		return

	_queue = valid_textures.duplicate()
	_open = true
	visible = true

	# lock player input while tutorial is shown
	if GameState.player:
		GameState.player.input_locked = true

	print("show_screens: queue size =", _queue.size())

	_show_next()

func _unhandled_input(event: InputEvent) -> void:
	if not _open:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		print("Any key pressed, going to next tutorial screen")
		_show_next()


func _show_next() -> void:
	if _queue.is_empty():
		print("_show_next: queue empty, closing popup")
		_close()
	else:
		var tex = _queue.pop_front()
		print("_show_next: setting texture =", tex)

		if image_rect == null:
			print("ERROR: image_rect is NULL – check node path $Background/CenterContainer/ImageRect")
			return

		image_rect.visible = true
		image_rect.modulate = Color(1, 1, 1, 1)
		image_rect.texture = tex

		_fit_image_to_screen()



func _close() -> void:
	_open = false
	visible = false

	# unlock player input when tutorial closes
	if GameState.player:
		GameState.player.input_locked = false

	print("TutorialPopup closed")
	
	
func _fit_image_to_screen() -> void:
	if image_rect == null:
		return
	
	# fill the entire viewport
	var vp_size := get_viewport().get_visible_rect().size

	image_rect.anchor_left = 0.0
	image_rect.anchor_top = 0.0
	image_rect.anchor_right = 1.0
	image_rect.anchor_bottom = 1.0

	image_rect.offset_left = 0.0
	image_rect.offset_top = 0.0
	image_rect.offset_right = 0.0
	image_rect.offset_bottom = 0.0


	image_rect.custom_minimum_size = vp_size


	image_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	image_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
