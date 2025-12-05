# AltarInteraction.gd
# Handles player proximity detection and shop interaction for the altar
extends Area2D

# References
@onready var interaction_prompt: Label = $InteractionPrompt
var shop_ui: CanvasLayer = null
var player_in_range: bool = false


func _ready() -> void:
	# Connect Area2D signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	# Find shop UI reference
	_find_shop()

	# Hide prompt initially
	if interaction_prompt:
		interaction_prompt.visible = false


func _find_shop() -> void:
	# Wait for scene tree to be ready
	await get_tree().process_frame
	shop_ui = get_tree().get_first_node_in_group("shop")

	if shop_ui == null:
		push_warning("AltarInteraction: Shop UI not found! Make sure Shop scene is in the tree and has group 'shop'")


func _process(_delta: float) -> void:
	# Check for interaction input when player is in range
	if player_in_range and Input.is_action_just_pressed("interact"):
		_open_shop()


func _on_body_entered(body: Node2D) -> void:
	# Check if the entering body is the player
	if body.is_in_group("Player"):
		player_in_range = true
		if interaction_prompt:
			interaction_prompt.visible = true


func _on_body_exited(body: Node2D) -> void:
	# Check if the exiting body is the player
	if body.is_in_group("Player"):
		player_in_range = false
		if interaction_prompt:
			interaction_prompt.visible = false


func _open_shop() -> void:
	if shop_ui == null:
		_find_shop()
		await get_tree().process_frame

	if shop_ui and shop_ui.has_method("open_shop"):
		shop_ui.open_shop()
	else:
		push_warning("AltarInteraction: Could not open shop!")
