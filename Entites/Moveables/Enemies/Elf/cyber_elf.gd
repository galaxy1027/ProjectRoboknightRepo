extends base_enemy

class_name CyberElf

const bullet := preload("res://Entites/Moveables/Enemies/Elf/bullet.tscn")

var cooldown:bool = false

func _physics_process(delta: float) -> void:
	_state_handler()
	move_and_slide()

func _state_handler()->void:
	var frame = animation_handler()
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
				if !cooldown:
					change_state(ATTACKING)
			elif target != null:
				velocity = go_to(target.global_position)
				
			else:
				change_state(IDLE)
		ATTACKING:
			direction = target.global_position - self.global_position
			if frame == 3 and !cooldown:
				var new_bullet := bullet.instantiate()
				# set direction to target
				new_bullet.direction = target.global_position
				# spawn in bullet
				new_bullet.global_position = self.global_position
				get_parent().add_child(new_bullet)
				cooldown = true
				$cooldown.start()
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
			_animate_direction_string = "F"
		else:
			_animate_direction_string = "B"
	
	match STATE:
		DEAD:
			if !$AnimatedSprite2D.animation.contains("DIE"):
				$AnimatedSprite2D.play("DIE")
		IDLE:
			if !$AnimatedSprite2D.animation.contains("WALK"):
				$AnimatedSprite2D.play("WALK_F")
				$AnimatedSprite2D.pause()
		PURSUING:
			# Change animation if animation is not correct
			if !$AnimatedSprite2D.animation.contains("WALK"):
				$AnimatedSprite2D.play("WALK_"+_animate_direction_string)
			elif !$AnimatedSprite2D.animation.ends_with(_animate_direction_string):
				$AnimatedSprite2D.play("WALK_"+_animate_direction_string)
			
		ATTACKING:
			# Change animation if animation is not correct
			#print($AnimatedSprite2D.animation)
			if !$AnimatedSprite2D.animation.contains("ATTK"):
				$AnimatedSprite2D.play("ATTK_"+_animate_direction_string)
		_:
			printerr("ANIMATION STATE ERROR")
	
	return frame

func _on_death() -> void:
	change_state(DEAD)
	$HealthBox.disable()


# When player is in range
func _on_player_body_entered(body: Node2D) -> void:
	print("BODH!")
	target = body

# When player is out of range
func _on_player_body_exited(body: Node2D) -> void:
	change_state(IDLE)
	target = null


func _on_cooldown_timeout() -> void:
	cooldown = false
