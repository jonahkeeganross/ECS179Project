class_name DashCommand
extends Command


var _cooldown: float = 1.0
var _dash_length: float = 80
var _mult = 50

func execute(character: Character) -> Status:
	#var input = character.movement_speed
	if character.velocity.length() < 1:
		return Status.DONE # In the case that player is not moving dont dash
	var _cur_vel_norm = character.velocity.normalized()
	character.velocity =  _cur_vel_norm * _dash_length * _mult

	#print("DONE")
	#character.sprite.flip_h = false
	#character.change_facing(Character.Facing.RIGHT)
	return Status.DONE
