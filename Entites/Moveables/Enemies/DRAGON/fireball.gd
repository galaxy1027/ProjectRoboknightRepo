extends CharacterBody2D

@export var SPEED:float = 1200.0

var direction:Vector2

var _max_speed:Vector2

func _ready() -> void:
	$Timer.start()
	# point in direction and set velocity to direction
	self.look_at(direction)
	
	_max_speed = Vector2(SPEED*cos(rotation),SPEED*sin(rotation))
	velocity.x = _max_speed.x
	velocity.y = _max_speed.y


var distance:float = 0
func _physics_process(delta: float) -> void:
	distance += SPEED * delta
	move_and_slide()
	
	if distance > 5000:
		die()
	
	
	if abs(velocity.x) < abs(_max_speed.x) or abs(velocity.y) < abs(_max_speed.y):
		die()


func _on_timer_timeout() -> void:
	$CollisionShape2D.set_deferred("disabled", false)
	$HurtBox.enable()
	

func die()->void:
	velocity = Vector2.ZERO
	if $AnimatedSprite2D.animation != "DIE":
		$CollisionShape2D.set_deferred("disabled", true)
		$HurtBox.disable()
		$AnimatedSprite2D.play("DIE")
	elif $AnimatedSprite2D.frame == 3:
		self.queue_free()

func _on_hurt_box_i_hit() -> void:
	die()
