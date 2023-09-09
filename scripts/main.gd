extends Node3D

const MOUSE_SENSIBILITY = 0.3

@onready var inventory = $UI/Inventory

func capture_mouse(capture):
	if capture:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready():
	capture_mouse(!inventory.visible)
	pass

func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("quit"):
			capture_mouse(false)
			get_tree().quit()
			
		elif event.is_action_pressed("open inventory"):
			inventory.visible = !inventory.visible
			
			capture_mouse(!inventory.visible)
			
	elif event is InputEventMouseMotion and !inventory.visible:
		var angleX = deg_to_rad(-event.relative.y * MOUSE_SENSIBILITY)
		var angleY = deg_to_rad(-event.relative.x * MOUSE_SENSIBILITY)
		
		if $Player/Camera3D.rotation_degrees.x + angleX > 90:
			$Player/Camera3D.rotation_degrees.x = 90
		elif $Player/Camera3D.rotation_degrees.x + angleX < -90:
			$Player/Camera3D.rotation_degrees.x = -90
		else:
			$Player/Camera3D.rotate_object_local(Vector3(1, 0, 0), angleX)
			
		$Player/Camera3D.rotate_y(angleY)
		
		print($Player/Camera3D.rotation_degrees)
