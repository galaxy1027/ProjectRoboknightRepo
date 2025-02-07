extends Node2D

@export_dir var next_level


func _process(delta: float) -> void:
	if get_parent().get_node("./ENY").get_child_count() == 0:
		if $AnimatedSprite2D.frame == 0:
			$AnimatedSprite2D.play()
		$Area2D.set_deferred("monitoring", true)

func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file(next_level)
