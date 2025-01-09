extends Panel

var item: Item = Item.new()

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			item.increment()
		
		elif event.is_action_pressed("right_click"):
			item.decrement()
		
		if item.number > 1:
			$StackSize.text = str(item.number)
		else:
			$StackSize.text = ""
			
		$CenterContainer/ItemTexture.visible = item.number > 0
