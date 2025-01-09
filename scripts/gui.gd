extends MarginContainer

func _on_node_3d_debug_toggled():
	$Debug.visible = get_parent().debug
