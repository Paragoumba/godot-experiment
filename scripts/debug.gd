extends Label

func _process(delta: float) -> void:
	text = "Debug mode on
			FPS: %s" % [Engine.get_frames_per_second()]
