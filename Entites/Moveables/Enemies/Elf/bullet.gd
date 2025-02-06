extends CharacterBody2D

@export var SPEED:float = 100.0

var direction:Vector2

func _ready() -> void:
	# point in direction and set velocity to direction
	self.look_at(direction)
	
	velocity.x = SPEED*cos(rotation)
	velocity.y = SPEED*sin(rotation)

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if abs(velocity.x) < 1 and abs(velocity.y) < 1:
		queue_free()
