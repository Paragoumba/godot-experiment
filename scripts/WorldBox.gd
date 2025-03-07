extends Area3D

func _on_body_exited(body):
	if body.is_in_group("god"):
		return

	print(body.name + " has exited the world")
	body.position = get_parent().get_node("Platform/Spawn").position
	body.rotation = Vector3.ZERO

	if body.has_method("set_linear_velocity"):
		body.set_linear_velocity(Vector3.ZERO)
		body.set_angular_velocity(Vector3.ZERO)
	elif body.has_method("set_velocity"):
		body.set_velocity(Vector3.ZERO)

	if body.get_groups().has("basketball"):
		body.position = %SpherePosition.position
