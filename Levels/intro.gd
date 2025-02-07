extends Control

func _ready() -> void:
	$Button.grab_focus()


func _on_button_pressed() -> void:
	# Start main scene
	get_tree().change_scene_to_file("res://Levels/test_level.tscn")
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	# Exit
	get_tree().quit()
	pass # Replace with function body.
