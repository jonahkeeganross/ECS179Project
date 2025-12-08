extends CanvasLayer

signal item_purchased(item_type: String, cost: int)
signal shop_closed

@onready var control: Control = $Control
@onready var title_label: Label = $Control/Panel/TitleLabel
@onready var health_potion_button: Button = $Control/Panel/HealthPotionButton
@onready var damage_upgrade_button: Button = $Control/Panel/DamageUpgradeButton
@onready var stamina_upgrade_button: Button = $Control/Panel/StaminaUpgradeButton
@onready var close_button: Button = $Control/Panel/CloseButton
@onready var coin_label: Label = $Control/Panel/CoinLabel

var player: Player = null

# Shop item prices
const HEALTH_POTION_PRICE: int = 5
const DAMAGE_UPGRADE_PRICE: int = 15
const STAMINA_UPGRADE_PRICE: int = 10

func _ready() -> void:
	# Allow processing even when paused
	process_mode = Node.PROCESS_MODE_ALWAYS

	if control:
		control.visible = false

	# Connect button signals
	if health_potion_button:
		health_potion_button.pressed.connect(_on_health_potion_pressed)
	if damage_upgrade_button:
		damage_upgrade_button.pressed.connect(_on_damage_upgrade_pressed)
	if stamina_upgrade_button:
		stamina_upgrade_button.pressed.connect(_on_stamina_upgrade_pressed)
	if close_button:
		close_button.pressed.connect(_on_close_pressed)

	# Update button texts with prices
	if health_potion_button:
		health_potion_button.text = "Health Potion (" + str(HEALTH_POTION_PRICE) + " Shards)"
	if damage_upgrade_button:
		damage_upgrade_button.text = "Damage Upgrade (" + str(DAMAGE_UPGRADE_PRICE) + " Shards)"
	if stamina_upgrade_button:
		stamina_upgrade_button.text = "Stamina Upgrade (" + str(STAMINA_UPGRADE_PRICE) + " Shards)"

func open_shop(p: Player) -> void:
	player = p
	if control:
		control.visible = true
	get_tree().paused = true
	update_coin_display()
	update_button_states()

func close_shop() -> void:
	if control:
		control.visible = false
	get_tree().paused = false
	shop_closed.emit()

func update_coin_display() -> void:
	if player:
		coin_label.text = "✦ 💎 Shards: " + str(player.total_coins) + " 💎 ✦"

func update_button_states() -> void:
	if player:
		health_potion_button.disabled = player.total_coins < HEALTH_POTION_PRICE or player.health >= 100
		damage_upgrade_button.disabled = player.total_coins < DAMAGE_UPGRADE_PRICE
		stamina_upgrade_button.disabled = player.total_coins < STAMINA_UPGRADE_PRICE

func _on_health_potion_pressed() -> void:
	if player and player.total_coins >= HEALTH_POTION_PRICE and player.health < 100:
		player.total_coins -= HEALTH_POTION_PRICE
		player.health = min(player.health + 30, 100)
		player.set_health(player.health)
		BUS.player_coins_changed.emit(player.total_coins)
		item_purchased.emit("health_potion", HEALTH_POTION_PRICE)
		update_coin_display()
		update_button_states()

func _on_damage_upgrade_pressed() -> void:
	if player and player.total_coins >= DAMAGE_UPGRADE_PRICE:
		player.total_coins -= DAMAGE_UPGRADE_PRICE
		player._set_attack_hitbox_damage(player.right_attack_box.damage + 5)
		BUS.player_coins_changed.emit(player.total_coins)
		item_purchased.emit("damage_upgrade", DAMAGE_UPGRADE_PRICE)
		update_coin_display()
		update_button_states()

func _on_stamina_upgrade_pressed() -> void:
	if player and player.total_coins >= STAMINA_UPGRADE_PRICE:
		player.total_coins -= STAMINA_UPGRADE_PRICE
		player.pi.max_stamina += 20
		player.stamina = player.pi.max_stamina
		player.set_stamina(player.stamina)
		BUS.player_max_stamina_changed.emit(player.pi.max_stamina)
		BUS.player_coins_changed.emit(player.total_coins)
		item_purchased.emit("stamina_upgrade", STAMINA_UPGRADE_PRICE)
		update_coin_display()
		update_button_states()

func _on_close_pressed() -> void:
	close_shop()

func _process(delta: float) -> void:
	# Check for ESC key to close shop (works even when paused)
	if control and control.visible:
		if Input.is_action_just_pressed("ui_cancel"):
			close_shop()
			get_viewport().set_input_as_handled()

func _input(event: InputEvent) -> void:
	if control and control.visible and event.is_action_pressed("ui_cancel"):
		close_shop()
		get_viewport().set_input_as_handled()
