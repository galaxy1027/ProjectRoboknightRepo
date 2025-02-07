extends base_enemy

class_name CyberGoblin

func _physics_process(delta: float) -> void:
	_state_handler()
	move_and_slide()

func _state_handler()->void:
	match STATE:
		DEAD:
			if $AnimatedSprite2D.animation != "DIE":
				$AnimatedSprite2D.play("DIE")
			elif $AnimatedSprite2D.frame == 4:
				self.queue_free()
			pass
		IDLE:
			pass
		PURSUING:
			pass
		ATTACKING:
			pass
		_:
			printerr("ERROR ON GOBLIN STATE TREE")


func _on_death() -> void:
	change_state(DEAD)
	$HurtBox.disable()
	$HealthBox.disable()


func _on_body_entered(body: Node2D) -> void:
	if body.name.contains('player'):
		target = body
