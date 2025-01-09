extends Control

var player
var camera

class Vector:
	var start: Vector3
	var end: Vector3
	var width: float
	var color: Color
	
	func _init(_start, _end, _width, _color):
		start = _start
		end = _end
		width = _width
		color = _color

	func draw(node: Control, _camera: Camera3D):
		var _start: Vector2 = _camera.unproject_position(self.start)
		var _end: Vector2 = _camera.unproject_position(self.end)
		node.draw_line(_start, _end, color, width)
		draw_triangle(node, _end, _start.direction_to(_end), width*2, color)

	func draw_triangle(node, pos, dir, size, _color):
		var a = pos + dir * size
		var b = pos + dir.rotated(2*PI/3) * size
		var c = pos + dir.rotated(4*PI/3) * size
		var points = PackedVector2Array([a, b, c])
		node.draw_polygon(points, PackedColorArray([_color]))

class PropertyVector extends Vector:
	var object  # The node to follow
	var property  # The property to draw
	var scale  # Scale factor

	func _init(_object, _property, _scale, _width, _color):
		object = _object
		property = _property
		scale = _scale
		width = _width
		color = _color

	func draw(node: Control, camera):
		var _start: Vector2 = camera.unproject_position(object.global_transform.origin)
		var _end: Vector2 = camera.unproject_position(object.global_transform.origin + object.get(property) * scale)
		node.draw_line(_start, _end, color, width)
		draw_triangle(node, _end, _start.direction_to(_end), width*2, color)

var vectors = []  # Array to hold all registered values.

func add_vector_property(object, property, _scale, width, color):
	vectors.append(PropertyVector.new(object, property, _scale, width, color))

func add_vector(_start, _end, _width, _color):
	vectors.append(Vector.new(_start, _end, _width, _color))

func _process(_delta):
	if not self.visible:
		return
	queue_redraw()

func _draw():
	var _camera = get_viewport().get_camera_3d()
	for vector in vectors:
		vector.draw(self, _camera)
