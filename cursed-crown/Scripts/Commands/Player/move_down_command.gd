class_name MoveDownCommand
extends Command



func execute(character: Character) -> Status:
	var input = 1 * character.movement_speed
	character.velocity.y = input
	return Status.DONE
