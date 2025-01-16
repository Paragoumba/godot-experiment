extends StaticBody3D

signal ball_entered_basket

func _on_area_3d_body_entered(body):
	if body.get_groups().has("basketball"):
		body.position = $/root/Root/SpherePosition2.position
		ball_entered_basket.emit()
