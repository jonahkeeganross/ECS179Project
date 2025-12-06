class_name Altar
extends Area2D

var opened: bool = false
var player_is_inside: bool = false
var current_player: Player = null

var interact_prompt: Label = null

var tutorial_shown: bool = false
@onready var tutorial_popup: TutorialPopup = null


func _ready() -> void:
	add_to_group("Altar")

	# Try to get the interact prompt
	if has_node("InteractPrompt"):
		interact_prompt = get_node("InteractPrompt") as Label
		interact_prompt.visible = false
		print("Altar: InteractPrompt found and hidden")
	else:
		print("Altar: WARNING - No InteractPrompt child node found")

	print("Altar: Ready at position " + str(global_position))

	# Find the tutorial popup
	tutorial_popup = get_tree().get_first_node_in_group("TutorialPopup") as TutorialPopup


func _on_body_entered(body) -> void:
	if body in get_tree().get_nodes_in_group("Player"):
		print("Altar: Player entered altar area")
		player_is_inside = true
		current_player = body as Player

		# Show the interact prompt
		if interact_prompt:
			interact_prompt.visible = true

		# Show altar tutorial PNG once, the first time the player comes here
		if not tutorial_shown and tutorial_popup:
			tutorial_shown = true
			tutorial_popup.show_altar_tutorial()


func _on_body_exited(body) -> void:
	if body in get_tree().get_nodes_in_group("Player"):
		player_is_inside = false
		current_player = null

		# Hide the interact prompt
		if interact_prompt:
			interact_prompt.visible = false


func _process(delta) -> void:
	if player_is_inside and current_player != null:
		# Check for F key press (interact action)
		if Input.is_action_just_pressed("interact"):
			print("Altar: F key pressed, attempting to open shop")
			_open_shop()


func _open_shop() -> void:
	if current_player != null:
		print("Altar: Opening shop via ShopManager...")
		ShopManager.open_shop(current_player)
	else:
		print("Altar: ERROR - Cannot open shop: current_player is null")
