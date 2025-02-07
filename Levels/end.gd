extends Control


func _on_button_pressed() -> void:
	# Start main scene
	get_tree().change_scene_to_file("res://Levels/Intro.tscn")


func _on_button_2_pressed() -> void:
	# Exit
	get_tree().quit()
