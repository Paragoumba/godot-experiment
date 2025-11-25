extends Node2D

var parts_number: int = 3
@export var resolution: int = 10
@export var inner_space: float = 100
@export var length: float = 200

var part_size: float = 2 * PI / parts_number
var selected_part: Polygon2D = null
var gap: float = part_size / 10

func _ready() -> void:
	var points = []
	points.append(Vector2(cos(gap), sin(gap)) * length)
	points.append(Vector2(cos(part_size - gap), sin(part_size - gap)) * length)
	points.append(Vector2(cos(part_size - gap), sin(part_size - gap)) * inner_space)
	points.append(Vector2(cos(gap), sin(gap)) * inner_space)

	$part.polygon = points
	$part.rotation = 0#-part_size / 2 # Rotate to get the top one in the middle # TODO fixme doesn't work with parts_number=3

	for i in parts_number - 1:
		var new_part: Node2D = $part.duplicate()
		new_part.rotation = (i + 1.0) * part_size
		#new_part.rotation = (i + 1.0 / 2) * part_size # Rotate to get the top one in the middle # TODO fixme doesn't work with parts_number=3
		add_child(new_part)

func _input(event):
	var wheel: Node = get_parent()

	if !wheel.visible:
		selected_part = null
		return

	if event is InputEventMouseMotion:
		var wheel_position: Vector2 = wheel.global_position
		var wheel_size: Vector2 = wheel.size
		var wheel_center: Vector2 = (event.position - wheel_position + wheel_size / 2).normalized()
		var angle = atan2(wheel_center.y, wheel_center.x)

		if angle < 0:
			angle += 2 * PI

		for c in get_children():
			if angle <= c.rotation + part_size and angle > c.rotation:
				c.color = Color.RED
				c.scale = Vector2(1.1, 1.1)
				selected_part = c
			else:
				c.color = Color(0.8, 0.8, 0.8)
				c.scale = Vector2(1, 1)

	elif event is InputEventMouseButton:
		if selected_part != null:
			if event.is_action_pressed("click"):
				selected_part.scale += Vector2(0.1, 0.1)

			elif event.is_action_pressed("right_click"):
				selected_part.scale -= Vector2(0.1, 0.1)
