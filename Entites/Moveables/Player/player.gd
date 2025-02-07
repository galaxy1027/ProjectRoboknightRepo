extends CharacterBody2D

## The Player Node
class_name player

## Movement variables
@export_category("Movement")
@export var max_Speed:float = 300.0
@export var speed := 100.0
@export var friction := 100.0

const dagger: = preload("res://Entites/Moveables/Player/dagger.tscn")

var _cooldown:bool = false

var _dead:bool = false
signal _i_died()

func _physics_process(delta: float) -> void:
	if _dead: return
	_movement()
	_attack()
	
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("WALK_F")
		$AnimatedSprite2D.stop()
	elif abs(velocity.x) > abs(velocity.y):
		$AnimatedSprite2D.play("WALK_H")
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		if velocity.y > 0:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("WALK_F")
		else:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("WALK_B")

## Handles player movement
func _movement()->void:
	var direction:Vector2 =Vector2(
		Input.get_axis("LEFT","RIGHT"),
		Input.get_axis("UP", "DOWN")
	)
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	var change := Vector2(friction, friction)
	
	if direction.y != 0: change.y = speed
	if direction.x != 0: change.x = speed
	
	velocity = Vector2(
		move_toward(velocity.x, max_Speed*direction.x, change.y),
	move_toward(velocity.y, max_Speed*direction.y, change.x)
	)
	move_and_slide()

## Handles player's attack animations and logic
func _attack()->void:
	if !_cooldown: 
		$pivot.look_at(get_global_mouse_position())
	if Input.is_action_pressed("ATTACK") and !_cooldown:
		# spawn dagger
		var new_dagger := dagger.instantiate()
		# set direction to target
		new_dagger.direction = get_global_mouse_position() - self.global_position
		new_dagger.rotation = $pivot.rotation
		# spawn in bullet
		new_dagger.global_position = $pivot/knife.global_position
		get_parent().add_child(new_dagger)
		# hide current dagger
		$pivot/knife.set_deferred("visible", false)
		_cooldown = true
		$cooldown.start()

## Starts death script
func _on_death() -> void:
	print("I DIED!!")
	_dead = true
	$AnimationPlayer.play("Dead")


func _on_knock_back(direction:Vector2, weight:float) -> void:
	velocity = Vector2(weight*direction.x, weight*direction.y)
	move_and_slide()
	$AnimationPlayer.play("Hit")
	


func _on_cooldown_timeout() -> void:
	$pivot/knife.set_deferred("visible", true)
	_cooldown = false


func _on_animation_DEADplayer_animation_finished(anim_name: StringName) -> void:
	emit_signal("_i_died")
