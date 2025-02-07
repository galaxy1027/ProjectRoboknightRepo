extends CharacterBody2D

@export var SPEED:float = 800.0

var direction:Vector2

func _ready() -> void:
	$Timer.start()
	# point in direction and set velocity to direction
	self.look_at(direction)
	
	velocity.x = SPEED*cos(rotation)
	velocity.y = SPEED*sin(rotation)

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if abs(velocity.x) < 1 and abs(velocity.y) < 1:
		queue_free()


func _on_timer_timeout() -> void:
	$CollisionShape2D.set_deferred("disabled", false)
	$hurt_box.enable()
	


func _on_hurt_box_i_hit() -> void:
	queue_free()
