extends base_enemy

class_name GOLEM

func _physics_process(delta: float) -> void:
	_state_handler()
	move_and_slide()

var cooldown:bool = false

func _state_handler()->void:
	var frame = animation_handler()
	match STATE:
		DEAD:
			pass
		IDLE:
			if target != null:
				change_state(PURSUING)
		PURSUING:
			direction = target.global_position - self.global_position
			if target != null and global_position.distance_to(target.global_position) > 100:
				velocity = go_to(target.global_position)
			elif (target != null and !cooldown):
				velocity = Vector2.ZERO
				$hurt_box.hit_him()
				$hurt_box.hit_him()
				$hurt_box.hit_him()
				$hurt_box.hit_him()
				$hurt_box.disable()
				$cooldown.start()
			else:
				change_state(IDLE)
		_:
			printerr("ERROR ON GIANT STATE TREE")

func animation_handler()->int:
	const hurt_box_positions:Array[Vector2] = [Vector2(76.5, 0),Vector2(-76.5, 0),Vector2(62, 12),Vector2(-62, 12)]
	var h_b_pos = hurt_box_positions[0]
	var frame:int = $AnimatedSprite2D.frame
	var _animate_direction_string = "F";
	# determine if direction is more latteral or horizontal
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			if $AnimatedSprite2D.animation != "WALK_S" or $AnimatedSprite2D.flip_h:
				$AnimatedSprite2D.play("WALK_S")
				$AnimatedSprite2D.flip_h = false
		else:
			if $AnimatedSprite2D.animation != "WALK_S" or !$AnimatedSprite2D.flip_h:
				$AnimatedSprite2D.play("WALK_S")
				$AnimatedSprite2D.flip_h = true
	elif $AnimatedSprite2D.animation != "WALK":
		$AnimatedSprite2D.play("WALK")
		
	return frame

func _on_death() -> void:
	velocity = Vector2.ZERO
	change_state(DEAD)
	$HurtBox.disable()
	$HealthBox.disable()
	self.queue_free()

# When player is in range
func _on_player_body_entered(body: Node2D) -> void:
	target = body

# When player is out of range
func _on_player_body_exited(body: Node2D) -> void:
	change_state(IDLE)
	target = null


func _on_cooldown_timeout() -> void:
	cooldown = false
	$hurt_box.enable()
