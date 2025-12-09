class_name HUD
extends Control


@onready var stamina_bar: ProgressBar = $StaminaBar
@onready var health_bar: ProgressBar = $HealthBar
@onready var health_bar_animation: ProgressBar = $HealthAnimation
@onready var coin_count: Label = $CoinCount
@onready var stamina_label: Label = $StaminaLabel if has_node("StaminaLabel") else null
@onready var health_label: Label = $HealthLabel if has_node("HealthLabel") else null

var health_tween:Tween
var current_health: int = 100
var current_stamina: float = 100
var max_stamina: int = 100


func _ready() -> void:
	#print("DONE")
	health_tween = self.create_tween()
	#EventBus.show_boss_health.connect(show_health)
	#EventBus.hide_boss_health.connect(hide_health)
	BUS.player_stamina_changed.connect(on_change_stamina)
	BUS.player_health_changed.connect(on_change_health)
	BUS.player_coins_changed.connect(on_coin_change)
	BUS.player_max_stamina_changed.connect(on_max_stamina_changed)
	#EventBus.set_health_sig.connect(chane_health)
	#stamina_bar.visible = false
	#print(stamina_bar.value)
	#progress_bar.visible = true
	health_bar.value = 100
	health_bar_animation.value = 100
	stamina_bar.max_value = 100
	update_stamina_display()
	update_health_display()
	show_health()
	
func show_health() -> void:
	stamina_bar.visible = true
	health_bar.visible = true
	health_bar_animation.visible = true
	#print("SHOWING HEALTH")
	


func hide_health() -> void:
	health_bar.visible = false
	#print("HIDING HEALTH")
		
func on_change_stamina(new_stamina: float) -> void:
	current_stamina = new_stamina
	stamina_bar.value = new_stamina
	update_stamina_display()

func on_change_health(new_health: int) -> void:
	current_health = new_health
	if health_tween and health_tween.is_running():
		health_tween.kill()

	health_tween = self.create_tween()
	health_tween.tween_property(
		health_bar_animation,
		"value",
		new_health,
		0.25
		).set_delay(0.7).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	health_bar.value = new_health
	update_health_display()
	#print("SHOWING HEALTH")

func on_max_stamina_changed(new_max_stamina: int) -> void:
	max_stamina = new_max_stamina
	stamina_bar.max_value = new_max_stamina
	update_stamina_display()

func update_stamina_display() -> void:
	if stamina_label:
		stamina_label.text = str(int(current_stamina)) + "/" + str(max_stamina)

func update_health_display() -> void:
	if health_label:
		health_label.text = str(current_health) + "/100"

func on_coin_change(new_count: int) -> void:
	coin_count.text = "Shards: " + str(new_count) 
	
