extends base_enemy

func _process(delta: float) -> void:
	
	move_and_slide()

func _state_handler()->void:
	match STATE:
		DEAD:
			pass
		IDLE:
			pass
		WANDERING:
			pass
		PURSUING:
			pass
		ATTACKING:
			pass
		_:
			printerr("ERROR ON GOBLIN STATE TREE")


func _on_death() -> void:
	change_state(DEAD)
