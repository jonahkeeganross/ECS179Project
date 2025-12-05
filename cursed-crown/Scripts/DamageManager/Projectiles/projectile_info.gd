class_name ProjectileInfo



var type:CharacterSpec.spec = CharacterSpec.spec.ENEMY
var lifetime: float = 0;
var damage: int = 10
var speed: float = 0
var acceleration: float =0
var delay:float = 0
var pierce:int = 1
var rot:float = 1
var rot_vel:float = 1



func _init(type:CharacterSpec.spec,  damage:int, lifetime: float, delay:float,
		  speed: float, acceleration: float, rot: float, rot_vel: float, pierce:int = 1 ) -> void:
	self.type = type	
	self.damage =damage 
	self.lifetime = lifetime
	self.delay = delay
	self.speed = speed

	self.acceleration = acceleration
	self.rot = rot
	self.rot_vel = rot_vel
	self.pierce = pierce
	
