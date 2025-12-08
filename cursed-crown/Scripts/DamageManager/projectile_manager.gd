extends Node
class_name ProjectileManager


@export var fireball:PackedScene
@export var laser:PackedScene
@export var biglaser:PackedScene
@export var voidball:PackedScene

func _ready() -> void:
	BUS.connect("spawn_fireball", Callable(self, "spawn_fireball"))
	BUS.connect("spawn_voidball", Callable(self, "spawn_voidball"))
func spawn_fireball(pos:Vector2, projectInfo: Array[ProjectileInfo]):
	var new_projectile = fireball.instantiate() as FireBall
	add_child(new_projectile)
	new_projectile.initialize(pos, projectInfo)
	
func spawn_voidball(pos:Vector2, projectInfo: Array[ProjectileInfo]):
	var new_projectile = voidball.instantiate() as VoidBall
	add_child(new_projectile)
	new_projectile.initialize(pos, projectInfo)


func spawn_laser(pos:Vector2, projectInfo: Array[ProjectileInfo]):
	
	var new_projectile = laser.instantiate() as Laser
	add_child(new_projectile)
	new_projectile.initialize(pos, projectInfo)

func spawn_big_laser(pos:Vector2, projectInfo: Array[ProjectileInfo]):
	
	var new_projectile = biglaser.instantiate() as BigLaser
	add_child(new_projectile)
	new_projectile.initialize(pos, projectInfo)
