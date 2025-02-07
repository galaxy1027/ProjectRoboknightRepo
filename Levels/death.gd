extends Control

func _ready() -> void:
	get_parent().get_node("./Player").connect("_i_died", _on_player_died)
	pass

func _on_player_died():
	print("HE DIED")
	get_tree().paused = true
	$Camera2D.enabled = true
	$Camera2D.make_current()
	self.visible = true
	$Button.disabled = false
	$Button2.disabled = false



func _on_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_button_2_pressed() -> void:
	get_tree().quit()
