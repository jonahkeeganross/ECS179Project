class_name HUD
extends Control


@onready var stamina_bar: ProgressBar = $StaminaBar
@onready var progress_bar: ProgressBar = $ProgressBar


func _ready() -> void:
	print("DONE")
	#EventBus.show_boss_health.connect(show_health)
	#EventBus.hide_boss_health.connect(hide_health)
	
	#EventBus.set_health_sig.connect(chane_health)
	#stamina_bar.visible = false
	#print(stamina_bar.value)
	#progress_bar.visible = true
	
	show_health()
	
func show_health() -> void:
	stamina_bar.visible = true
	progress_bar.visible = true
	print("SHOWING HEALTH")
	


func hide_health() -> void:
	#health_bar.visible = false
	print("HIDING HEALTH")
		
func change_stamina(new_stamina: int) -> void:
	stamina_bar.value = new_stamina	
	
func change_health(new_health: int) -> void:
	#health_bar.value = new_health
	print("SHOWING HEALTH")
	
