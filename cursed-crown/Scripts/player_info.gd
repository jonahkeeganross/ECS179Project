class_name PlayerInfo

var player:Player


var move_speed:float = 40
var weight:float = 40

var stamina_recharge_time:float = 2.5
var stamina_recharge:float = 10
var stamina_acceleration:float = 10
var max_stamina:int = 100

var dash_stamina_cons:float = 10
var smash_stamina_cons:int = 40
var arrow_stamina_cons:int = 30
var attack_stamina_cons:int = 20

var smash_knockback:float = 15


var porjectile_sword = false

var projectile_number:int = 0
var projectile_spread:float  = 0
var projectile_pierce = 1



func _init(char:Character) -> void:
	player = char
	
	
