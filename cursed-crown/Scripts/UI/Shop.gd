# Shop.gd
# Handles the upgrade shop UI, purchasing upgrades, and player stat modifications
extends CanvasLayer

# Upgrade costs
const ATTACK_COST = 50
const HP_COST = 75
const SPEED_COST = 60

# Upgrade values
const ATTACK_BONUS = 5
const HP_BONUS = 20
const SPEED_BONUS = 30

# Node references
@onready var coins_label: Label = $PanelContainer/MarginContainer/VBoxContainer/CoinsLabel
@onready var attack_buy_button: Button = $PanelContainer/MarginContainer/VBoxContainer/UpgradesContainer/AttackUpgrade/BuyButton
@onready var hp_buy_button: Button = $PanelContainer/MarginContainer/VBoxContainer/UpgradesContainer/HPUpgrade/BuyButton
@onready var speed_buy_button: Button = $PanelContainer/MarginContainer/VBoxContainer/UpgradesContainer/SpeedUpgrade/BuyButton
@onready var close_button: Button = $PanelContainer/MarginContainer/VBoxContainer/CloseButton

# Player reference
var player: CharacterBody2D = null


func _ready() -> void:
	# Hide shop initially
	visible = false

	# Connect button signals
	attack_buy_button.pressed.connect(_on_attack_buy_pressed)
	hp_buy_button.pressed.connect(_on_hp_buy_pressed)
	speed_buy_button.pressed.connect(_on_speed_buy_pressed)
	close_button.pressed.connect(_on_close_pressed)

	# Find player reference
	_find_player()


func _find_player() -> void:
	# Wait for scene tree to be ready, then find player
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")

	if player == null:
		push_warning("Shop: Player not found in scene tree!")


func open_shop() -> void:
	if player == null:
		_find_player()
		await get_tree().process_frame

	visible = true
	get_tree().paused = true
	_update_ui()


func close_shop() -> void:
	visible = false
	get_tree().paused = false


func _update_ui() -> void:
	if player == null:
		return

	# Update coins display
	coins_label.text = "Coins: %d" % player.coins

	# Update button states based on affordability
	attack_buy_button.disabled = player.coins < ATTACK_COST
	hp_buy_button.disabled = player.coins < HP_COST
	speed_buy_button.disabled = player.coins < SPEED_COST


func _purchase_upgrade(cost: int, upgrade_type: String) -> bool:
	if player == null:
		push_warning("Shop: Cannot purchase - player reference lost!")
		return false

	if player.coins < cost:
		push_warning("Shop: Not enough coins!")
		return false

	# Deduct coins
	player.coins -= cost

	# Apply upgrade
	match upgrade_type:
		"attack":
			player.attack_damage += ATTACK_BONUS
			print("Shop: Attack upgraded! New damage: ", player.attack_damage)
		"hp":
			player.max_health += HP_BONUS
			player.health += HP_BONUS  # Also heal the player
			print("Shop: Max HP upgraded! New max HP: ", player.max_health)
		"speed":
			player.movement_speed += SPEED_BONUS
			print("Shop: Speed upgraded! New speed: ", player.movement_speed)

	# Update UI
	_update_ui()
	return true


# Button callbacks
func _on_attack_buy_pressed() -> void:
	_purchase_upgrade(ATTACK_COST, "attack")


func _on_hp_buy_pressed() -> void:
	_purchase_upgrade(HP_COST, "hp")


func _on_speed_buy_pressed() -> void:
	_purchase_upgrade(SPEED_COST, "speed")


func _on_close_pressed() -> void:
	close_shop()


# Allow ESC key to close shop
func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close_shop()
		get_viewport().set_input_as_handled()
