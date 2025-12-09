class_name HitBox
extends Area2D

@export var damage:int = 10
@export var collision_shape:CollisionObject2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 8
	area_entered.connect(_on_area_entered)


func _on_area_entered(hurtbox:HurtBox) -> void:
	#print("ENTERED")
	#print(.name)
	if hurtbox.get_owner() != self.owner:
		if hurtbox.get_owner().has_method("take_damage"):
			#print("DAMAGE")
			hurtbox.owner.take_damage(damage)
