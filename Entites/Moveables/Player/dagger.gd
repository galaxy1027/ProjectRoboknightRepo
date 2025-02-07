extends CharacterBody2D

@export var SPEED:float = 900.0

var direction:Vector2

var _max_speed:Vector2

func _ready() -> void:
	$Sprite2D.flip_h = true
	
	_max_speed = Vector2(SPEED*cos(rotation),SPEED*sin(rotation))
	velocity.x = _max_speed.x
	velocity.y = _max_speed.y

var distance:float = 0
func _physics_process(delta: float) -> void:
	move_and_slide()
	distance += SPEED * delta
	if distance > 5000:
		queue_free()
	
	if abs(velocity.x) < abs(_max_speed.x) or abs(velocity.y) < abs(_max_speed.y):
		queue_free()


func _on_hurt_box_i_hit() -> void:
	velocity = Vector2.ZERO
	queue_free()
