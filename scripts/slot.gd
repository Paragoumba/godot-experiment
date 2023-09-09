extends Panel

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			var child = $TextureRect
			child.visible = !child.visible
