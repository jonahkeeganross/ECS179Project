class_name HUD
extends Control


@onready var stamina_bar: ProgressBar = $StaminaBar
@onready var health_bar: ProgressBar = $HealthBar
@onready var health_bar_animation: ProgressBar = $HealthAnimation
@onready var coin_count: Label = $CoinCount


var health_tween:Tween


func _ready() -> void:
	print("DONE")
	health_tween = self.create_tween()
	#EventBus.show_boss_health.connect(show_health)
	#EventBus.hide_boss_health.connect(hide_health)
	BUS.player_stamina_changed.connect(on_change_stamina)
	BUS.player_health_changed.connect(on_change_health)
	BUS.player_coins_changed.connect(on_coin_change)
	#EventBus.set_health_sig.connect(chane_health)
	#stamina_bar.visible = false
	#print(stamina_bar.value)
	#progress_bar.visible = true
	health_bar.value = 100
	health_bar_animation.value = 100
	show_health()
	
func show_health() -> void:
	stamina_bar.visible = true
	health_bar.visible = true
	health_bar_animation.visible = true
	print("SHOWING HEALTH")
	


func hide_health() -> void:
	#health_bar.visible = false
	print("HIDING HEALTH")
		
func on_change_stamina(new_stamina: float) -> void:
	stamina_bar.value = new_stamina	
	
func on_change_health(new_health: int) -> void:
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
	print("SHOWING HEALTH")
	

func on_coin_change(new_count: int) -> void:
	coin_count.text = "Shards: " + str(new_count) 
	
