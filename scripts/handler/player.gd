extends CharacterBody3D

const MOUSE_SENSIVITY = 0.3
const CONTROLLER_SENSIVITY = 1.5 # TODO Not smooth
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const RAY_LENGTH = 5

var inventory: Node
var player: Node
var camera: Node
var animationPlayer: AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func processCameraRotation(relative: Vector2):
	var angleX = deg_to_rad(-relative.x)
	var angleY = deg_to_rad(-relative.y)
	
	if camera.rotation_degrees.x + angleX > 90:
		camera.rotation_degrees.x = 90
	elif camera.rotation_degrees.x + angleX < -90:
		camera.rotation_degrees.x = -90
	else:
		camera.rotate_object_local(Vector3.RIGHT, angleX)
		
	player.rotate_y(angleY)

func _ready():
	load_nodes()

func load_nodes():
	inventory = $/root/Root/UI/Inventory
	player = $/root/Root/Player
	camera = $/root/Root/Player/FirstPersonCamera
	animationPlayer = $'character-human'/AnimationPlayer

func _physics_process(delta):
	#print(velocity, is_on_floor())

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("leftward", "rightward", "forward", "backward")
	
	if input_dir.length() > 0:
		$MovePointVis.position = $MovePoint.position + Vector3(input_dir.x, 0, input_dir.y)

	input_dir = input_dir.rotated(-rotation.y)
	#print(input_dir.length())
	#$MovePointVis.position = $MovePoint.position + Vector3(input_dir.length(), 0, input_dir.length())

	#print(input_dir)

	velocity.x = input_dir.x * SPEED
	velocity.z = input_dir.y * SPEED

	move_and_slide()
	
func _input(event):
	if !inventory.visible:
		var relative = Vector2()
		var cameraMoved = false
		
		if event is InputEventMouseMotion:
			cameraMoved = true
			relative.x = event.relative.y * MOUSE_SENSIVITY
			relative.y = event.relative.x * MOUSE_SENSIVITY
			
		elif event is InputEventJoypadMotion:
			cameraMoved = true
			relative = Input.get_vector("look_up", "look_down", "look_left", "look_right") * CONTROLLER_SENSIVITY
		
		if cameraMoved:
			processCameraRotation(relative)
		
	if event.is_action_pressed("kick"):
			animationPlayer.play("attack-melee-left")
			Input.start_joy_vibration(0, 1, 0, 0.3)

			var space_state = get_world_3d().direct_space_state
			var mousepos = get_viewport().get_mouse_position()

			var origin = camera.project_ray_origin(mousepos)
			var end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH
			var query = PhysicsRayQueryParameters3D.create(origin, end)

			var result = space_state.intersect_ray(query)

			if !result.is_empty():
				var object: Node = result.collider
				if object.is_in_group("enemy"):
					object.hit()
				
				elif "linear_velocity" in object:
					object.linear_velocity += (object.position - origin).normalized() * RAY_LENGTH * 5
