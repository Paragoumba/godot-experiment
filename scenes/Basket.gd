extends StaticBody3D

func _on_area_3d_body_entered(body):
	if body.get_groups().has("basketball"):
		body.position = $/root/Root/SpherePosition.position
