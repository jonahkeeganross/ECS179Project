extends Node


signal queue_dialogue(lines:Array[String])
#signal change_stamina(new_stamina:Int)
signal test

signal spawn_fireball(pos:Vector2, projectileInfo: Array[ProjectileInfo])
signal spawn_voidball(pos:Vector2, projectileInfo: Array[ProjectileInfo])
signal player_stamina_changed(new_stamina:float)
signal player_health_changed(new_health:float)
signal player_coins_changed(new_coins:float)
signal player_max_stamina_changed(new_max_stamina:int)
