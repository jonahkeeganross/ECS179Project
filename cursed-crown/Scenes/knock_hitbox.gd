class_name KnockbackHitBox
extends Area2D

@export var damage:int = 10
@export var knockback_strength:int = 500



func _init() -> void:
	collision_layer = 0
	collision_mask = 8
	area_entered.connect(_on_area_entered)


func _on_area_entered(hurtbox:HurtBox) -> void:
	var player_pos:Vector2 = self.get_parent().global_position
	#print("ENTERED")
	#print(.name)
	if hurtbox.get_owner() != self.owner:
		if hurtbox.get_owner().has_method("take_damage"):
			hurtbox.owner.take_damage(damage)
		if hurtbox.get_owner().has_method("apply_knockback"):
			var dir = (player_pos  - hurtbox.global_position).normalized()
			hurtbox.owner.apply_knockback(dir, knockback_strength)
			hurtbox.owner.take_damage(damage)
