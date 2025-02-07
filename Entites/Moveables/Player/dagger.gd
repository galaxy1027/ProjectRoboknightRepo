extends CharacterBody2D

@export var SPEED:float = 900.0

var direction:Vector2

func _ready() -> void:
	$Sprite2D.flip_h = true
	
	velocity.x = SPEED*cos(rotation)
	velocity.y = SPEED*sin(rotation)

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if abs(velocity.x) < 30 and abs(velocity.y) < 30:
		queue_free()


func _on_hurt_box_i_hit() -> void:
	queue_free()
