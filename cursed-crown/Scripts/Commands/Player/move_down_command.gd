class_name MoveDownCommand
extends Command


func execute(character: Character) -> Status:
	var input = character.movement_speed
	character.velocity.x = input
	character.sprite.flip_h = false
	character.change_facing(Character.Facing.RIGHT)
	return Status.DONE
