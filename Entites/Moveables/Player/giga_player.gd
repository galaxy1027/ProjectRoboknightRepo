extends CharacterBody2D

## The Player Node
class_name giga_player

## Movement variables
@export_category("Movement")
@export var max_Speed:float = 300.0
@export var speed := 100.0
@export var friction := 100.0

const bullet: = preload("res://Entites/Moveables/Player/bullet2.tscn")

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
	$pivot.look_at(get_global_mouse_position())
	var flipped = gat_hanle()
	if Input.is_action_pressed("ATTACK"):
		if $pivot/AnimatedSprite2D.frame < 4:
			$pivot/AnimatedSprite2D.play()
		if !_cooldown:
			# spawn dagger
			var new_bullet := bullet.instantiate()
			# set direction to target
			if (!flipped and false):
				new_bullet.direction = -(get_global_mouse_position() - self.global_position)
				new_bullet.rotation = -$pivot.rotation
			else:
				new_bullet.direction = get_global_mouse_position() - self.global_position
				new_bullet.rotation = $pivot.rotation
			# spawn in bullet
			new_bullet.global_position = $pivot/AnimatedSprite2D/Marker2D.global_position
			get_parent().add_child(new_bullet)
			_cooldown = true
			$cooldown.start()
	elif $pivot/AnimatedSprite2D.frame > 0:
		$pivot/AnimatedSprite2D.play_backwards()
		

func gat_hanle() -> bool:
	if cos($pivot.rotation) < 0:
		$pivot/AnimatedSprite2D.flip_v = true
		$pivot/AnimatedSprite2D.position = Vector2(42,-61)
		return true
	else:
		$pivot/AnimatedSprite2D.flip_v = false
		$pivot/AnimatedSprite2D.position = Vector2(42,61)
		return false

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
	_cooldown = false
