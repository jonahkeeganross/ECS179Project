extends Node
class_name ProjectileManager


@export var fireball:PackedScene
@export var laser:PackedScene

func spawn_fireball(pos:Vector2, projectInfo: ProjectileInfo):
	var new_projectile = fireball.instantiate() as FireBall
	add_child(new_projectile)
	new_projectile.initialize(pos, projectInfo)


func spawn_laser(pos:Vector2, projectInfo: ProjectileInfo):
	
	var new_projectile = laser.instantiate() as Laser
	add_child(new_projectile)
	new_projectile.initialize(pos, projectInfo)
