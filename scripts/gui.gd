extends MarginContainer

var counter = 0

func _on_node_3d_debug_toggled():
	$Debug.visible = get_parent().debug

func _on_basket_ball_entered_basket():
	counter += 1
	print(counter)
	$Counter.text = "Counter: " + str(counter)
