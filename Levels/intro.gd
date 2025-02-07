extends Control

func _ready() -> void:
	$Button.grab_focus()


func _on_button_pressed() -> void:
	# Start main scene
	get_tree().change_scene_to_file("res://Levels/LEVEL1.tscn")
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	# Exit
	get_tree().quit()
