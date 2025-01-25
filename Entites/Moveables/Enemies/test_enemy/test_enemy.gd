extends base_enemy

## A dummy enemy to test code with
class_name test_enemy

# Overwrite enums for some stuff
# enum {idle, running, exploading, dead}

func _process(delta: float) -> void:
	if STATE != WANDERING:
		change_state(WANDERING)
	
	_state_handeler()
	
	move_and_slide()

func _state_handeler():
	match STATE:
		DEAD:
			pass
		IDLE:
			if abs(velocity) > Vector2.ZERO:
				velocity = Vector2.ZERO
		WANDERING:
			velocity = go_to(Vector2.ZERO)
		_:
			pass
