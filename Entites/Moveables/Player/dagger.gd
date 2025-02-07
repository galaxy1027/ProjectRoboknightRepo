extends CharacterBody2D

@export var SPEED:float = 900.0

var direction:Vector2

func _ready() -> void:
	$Sprite2D.flip_h = true
	
	velocity.x = SPEED*cos(rotation)
	velocity.y = SPEED*sin(rotation)

var distance:float = 0
func _physics_process(delta: float) -> void:
	move_and_slide()
	distance += SPEED * delta
	if distance > 5000:
		queue_free()
	
	if abs(velocity.x) < 30 and abs(velocity.y) < 30:
		queue_free()


func _on_hurt_box_i_hit() -> void:
	velocity = Vector2.ZERO
	queue_free()
