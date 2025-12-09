class_name Coin
extends StaticBody2D
@onready var coin_sound: AudioStreamPlayer2D = $coinSound

var coin_speed : float = 400
var player : Player

func _physics_process(delta: float) -> void:
	player = GameState.player
	if player == null:
		return
	
	if abs((global_position - player.global_position).length()) < 1:
		$AnimatedSprite2D.visible = false
		player.total_coins += 1
		BUS.player_coins_changed.emit(player.total_coins)
		queue_free()
		
		
	else:
		global_position = lerp(global_position, player.global_position, 0.2)
	
