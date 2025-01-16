extends Node3D

signal debug_toggled

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const MOUSE_SENSIVITY = 0.3
const RAY_LENGTH = 5
const GOD_GROUP = "god"

@onready var inventory = $UI/Inventory
@onready var map = $UI/Map

@export var playerHandler: Script
@export var godHandler: Script

var debug = false

func print_child(depth, parent):
	var path = get_path_to(parent)
	print('-'.repeat(depth), parent, path, get_node(path) == parent)
	
	for child in parent.get_children():
		print_child(depth + 1, child)

func capture_mouse(capture):
	if capture:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready():
	RenderingServer.set_debug_generate_wireframes(true)
	capture_mouse(!inventory.visible)
	
	var cam = $Player/FirstPersonCamera
	var origin = cam.position * cam.rotation + Vector3.FORWARD * RAY_LENGTH
	
	$Player/FirstPersonCamera/MousePos.position = origin
	
#func _process(_delta):
	#var cam = $Player/Camera3D
	#var mousepos = get_viewport().get_mouse_position()
	#var origin = cam.project_ray_origin(mousepos) + cam.project_ray_normal(mousepos) * RAY_LENGTH
	#
	#$Player/Camera3D/MousePos.position = origin

func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("quit"):
			capture_mouse(false)
			get_tree().quit()
			
		elif event.is_action_pressed("open_inventory"):
			map.visible = inventory.visible
			inventory.visible = !inventory.visible
			
			capture_mouse(!inventory.visible)
			
		elif event.is_action_pressed("debug"):
			debug = !debug
			emit_signal("debug_toggled")
			
			var player = $Player
			
			player.set_script(godHandler if debug else playerHandler)
			player.load_nodes()
			
			if debug:
				player.add_to_group(GOD_GROUP)
			else:
				player.remove_from_group(GOD_GROUP)
			
			# TODO Fix ready not being run again in player
			
		elif debug and event.is_action_pressed("debug_draw"):
			var vp = get_viewport()
			vp.debug_draw = (vp.debug_draw + 1 ) % (Viewport.DEBUG_DRAW_WIREFRAME + 1)
			
			match vp.debug_draw:
				Viewport.DEBUG_DRAW_WIREFRAME:
					RenderingServer.set_default_clear_color(Color(0, 0, 0))
					$Skybox.visible = false
					
				_:
					RenderingServer.set_default_clear_color(Color(0.3, 0.3, 0.3))
					$Skybox.visible = true
			
		elif event.is_action_pressed("fullscreen"):
			var window: Window = get_window()
			
			if window.mode == Window.MODE_WINDOWED:
				window.mode = Window.MODE_FULLSCREEN
			else:
				window.mode = Window.MODE_WINDOWED

		elif event.is_action_pressed("run"):
			var player = $Player

			player.running = !player.running
			
	#elif (event is InputEventMouseMotion or event is InputEventJoypadMotion) and !inventory.visible:
		#var angleX = deg_to_rad(-event.relative.y * MOUSE_SENSIVITY)
		#var angleY = deg_to_rad(-event.relative.x * MOUSE_SENSIVITY)
		#
		#if $Player/Camera3D.rotation_degrees.x + angleX > 90:
			#$Player/Camera3D.rotation_degrees.x = 90
		#elif $Player/Camera3D.rotation_degrees.x + angleX < -90:
			#$Player/Camera3D.rotation_degrees.x = -90
		#else:
			#$Player/Camera3D.rotate_object_local(Vector3.RIGHT, angleX)
			#
		#$Player.rotate_y(angleY)
