extends base_enemy

class_name CyberElf

const bullet := preload("res://Entites/Moveables/Enemies/Elf/bullet.tscn")

func _process(delta: float) -> void:
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
			if target != null:
				change_state(PURSUING)
		PURSUING:
			# When get to a distance shoot at player
			if global_position.distance_to(target.global_position) < 1000:
				velocity = Vector2.ZERO
				change_state(ATTACKING)
			elif target != null:
				velocity = go_to(target.global_position)
			else:
				change_state(IDLE)
		ATTACKING:
			var frame = animation_handler()
			if frame == 3:
				var new_bullet := bullet.instantiate()
				# set direction to target
				new_bullet.direction = position.direction_to(target.global_position)
				# spawn in bullet
				new_bullet.global_position = $AnimatedSprite2D/Marker2D.global_position
				get_parent().add_child(new_bullet)
			elif frame == 5:
				change_state(IDLE)
		_:
			printerr("ERROR ON ELF STATE TREE")

func animation_handler()->int:
	var frame:int = $AnimatedSprite2D.frame
	var _animate_direction_string = "F";
	# determine if direction is more latteral or horizontal
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			_animate_direction_string = "R"
		else:
			_animate_direction_string = "L"
	else:
		if direction.y > 0:
			_animate_direction_string = "B"
		else:
			_animate_direction_string = "F"
	
	match STATE:
		DEAD:
			if !$AnimatedSprite2D.animation.contains("DIE"):
				$AnimatedSprite2D.play("DIE")
		IDLE:
			pass
		PURSUING:
			# Change animation if animation is not correct
			if !$AnimatedSprite2D.animation.contains("WALK"):
				$AnimatedSprite2D.play("WALK"+_animate_direction_string)
			elif !$AnimatedSprite2D.animation.ends_with(_animate_direction_string):
				$AnimatedSprite2D.play("WALK"+_animate_direction_string)
			
		ATTACKING:
			# Change animation if animation is not correct
			if !$AnimatedSprite2D.animation.contains("WALK"):
				$AnimatedSprite2D.play("WALK"+_animate_direction_string)
		_:
			printerr("ANIMATION STATE ERROR")
	
	return frame

func _on_death() -> void:
	change_state(DEAD)
	$HealthBox.disable()


# When player is in range
func _on_player_body_entered(body: Node2D) -> void:
	target = body

# When player is out of range
func _on_player_body_exited(body: Node2D) -> void:
	change_state(IDLE)
	target = null
