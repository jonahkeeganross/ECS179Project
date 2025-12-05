extends CharacterBody2D

@onready var anim_play:AnimationPlayer =  $AnimationPlayer
@onready var animation_tree:AnimationTree =  $AnimationTree
@onready var sprt:Sprite2D =  $Sprite2D
@onready var spawn_timer:Timer =  $Timer


var total_time:float= 0

func _ready() -> void:
	print("ready")
	visible = true
	sprt.visible = true	
	
func _process(delta: float) -> void:
	total_time += delta
	if total_time > 3:
		print("YASD")
		
		animation_tree["parameters/conditions/boss_sp_attack2"] = true
		total_time = 0
	else:
		animation_tree["parameters/conditions/boss_sp_attack2"] = false	
		
func emit_balls_lr():
	for i in range(10):
			#var new_projectile = projectile.instantiate() as FireBall
			spawn_timer.start(0.1)
			await spawn_timer.timeout
			var dir_deg = 180 - i * 36
			var projectile_list: Array[ProjectileInfo] = []
			var projectile_info = ProjectileInfo.new(
				CharacterSpec.spec.ENEMY, 
				10, # damage
				4, # Lifetime
				0.1, # Spawn delay
				20, # Speed
				70, # Acceleration
				dir_deg, # Initial Rotation
				0 # Initial Rot velocity 
				)
			projectile_list.append(projectile_info)
			
			var new_pos = global_position + Vector2.from_angle(deg_to_rad(dir_deg)) * 10
			BUS.emit_signal("spawn_voidball", new_pos , projectile_list)
