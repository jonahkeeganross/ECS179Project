extends Marker2D

var total_time:float = 0
var cooldown:float = 3

@onready var projectile_manager = %ProjectileManager

@export var	projectile:PackedScene
@export var projectile_spawn:Node2D


	
func _process(delta: float) -> void:
	total_time += delta
	if total_time > cooldown:
		#_emit()
		total_time = 0
	
func _emit():
	print("EM<IT")
	for i in range(20):
		#await get_tree().create_timer(0.1).timeout
		#var new_projectile = projectile.instantiate() as FireBall
		var projectile_list: Array[ProjectileInfo] = []
		var projectile_info = ProjectileInfo.new(
		CharacterSpec.spec.ENEMY, 
			10, # damage
			2, # Lifetime
			1, # Spawn delay
			0, # Speed
			0, # Accelerat ion
			i * 36, # Initial Rotation
			20 # Initial Rot velocity 
		)
		projectile_list.append(projectile_info)
		projectile_manager.spawn_laser(global_position, projectile_list)

	
	
