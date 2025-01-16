extends CharacterBody3D

const MOUSE_SENSIVITY = 0.3
const SPEED = 10.0
const JUMP_VELOCITY = 4.5

var running: bool = false

var player: Node
var camera: Node
var inventory: Node

func load_nodes():
	player = $/root/Root/Player
	camera = $/root/Root/Player/FirstPersonCamera
	inventory = $/root/Root/UI/Inventory

func _ready():
	load_nodes()

func _physics_process(delta):
	if Input.is_action_pressed("jump"):
		position.y += JUMP_VELOCITY * delta
	elif Input.is_action_pressed("crouch"):
		position.y -= JUMP_VELOCITY * delta

	var input_dir = Input.get_vector("leftward", "rightward", "forward", "backward").rotated(-rotation.y)

	#if input_dir.length() > 0:
	#	$MovePointVis.position = $MovePoint.position + Vector3(input_dir.x, 0, input_dir.y)

	if input_dir:
		var trueSpeed = SPEED * 2 if running else SPEED
		input_dir *= trueSpeed
		position.x += input_dir.x * delta
		position.z += input_dir.y * delta

func _input(event):
	if !$/root/Root/UI/Inventory.visible:
		if event is InputEventMouseMotion:
			var angleX = deg_to_rad(-event.relative.y * MOUSE_SENSIVITY)
			var angleY = deg_to_rad(-event.relative.x * MOUSE_SENSIVITY)

			if camera.rotation_degrees.x + angleX > 90:
				camera.rotation_degrees.x = 90
			elif camera.rotation_degrees.x + angleX < -90:
				camera.rotation_degrees.x = -90
			else:
				camera.rotate_object_local(Vector3.RIGHT, angleX)

			player.rotate_y(angleY)

		#elif event is InputEventJoypadMotion
