extends Node3D

signal world_generated

@export var block: PackedScene

@onready var normal_shader: Shader = preload("res://shaders/normals.gdshader")

var width: int = 51
var height: int = 51
var blockScale: float = 0.25
var amplification = 20

@export var cx: int = 0
@export var cz: int = 0

func generate(noise: Noise):
	gen_surface(noise)

	var image = noise.get_image(width, height, false, false, false)
	world_generated.emit(image)

func get_noise_2d(noise: Noise, x, y):
	return noise.get_noise_2d(x, y) * amplification

func gen_blocks(noise: Noise):
	for x in width:
		for y in height:
			var b = block.instantiate()
			var blockHeight = noise.get_noise_2d(x, y)

			b.scale = Vector3(blockScale, blockScale, blockScale)
			b.position = Vector3((x - float(width) / 2) * blockScale, blockHeight + 0.1, (y - float(blockHeight) / 2) * blockScale)

			add_child(b)

func gen_surface(noise: Noise):
	print("Generating chunk ", name)
	
	var st = SurfaceTool.new()
	var mapdata = PackedFloat32Array()

	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	print(range(cx * width, cx * width + width), " ", range(cz * height, cz * height + height))

	for z in range(height):
		for x in range(width):
			var absX = cx * width + x
			var absZ = cz * height + z
			
			var y = get_noise_2d(noise, absX, absZ)
			
			mapdata.append(y)
			
			if x != 0 && z != 0:
				var v1 = Vector3(x, y, z)
				var v2 = Vector3(x - 1, mapdata[(x - 1) + (z - 1) * height], z - 1)
				var v3 = Vector3(x, mapdata[x + (z - 1) * height], z - 1)
				var v4 = Vector3(x - 1, mapdata[(x - 1) + z * height], z)

				# Triangle 1
				var normal = (v4 - v1).cross(v1 - v3).normalized()
				st.set_normal(normal)
				st.set_uv(Vector2(0, 0))
				st.set_color(Color.BLUE)
				st.add_vertex(v1)

				st.set_normal(normal)
				st.set_uv(Vector2(1, 1))
				st.set_color(Color.RED)
				st.add_vertex(v4)

				st.set_normal(normal)
				st.set_uv(Vector2(0, 1))
				st.set_color(Color.GREEN)
				st.add_vertex(v3)

				# Triangle 2
				normal = (v3 - v4).cross(v2 - v4).normalized()
				st.set_normal(normal)
				st.set_uv(Vector2(0, 0))
				st.set_color(Color.BLUE)
				st.add_vertex(v4)

				st.set_normal(normal)
				st.set_uv(Vector2(1, 1))
				st.set_color(Color.RED)
				st.add_vertex(v2)

				st.set_normal(normal)
				st.set_uv(Vector2(0, 1))
				st.set_color(Color.GREEN)
				st.add_vertex(v3)

	# Commit to a mesh.
	var mesh: ArrayMesh = st.commit()
	var material: ShaderMaterial = ShaderMaterial.new()

	material.shader = normal_shader
	mesh.surface_set_material(0, material)
	$Mesh.mesh = mesh

	var shape: HeightMapShape3D = HeightMapShape3D.new()

	shape.map_width = width
	shape.map_depth = height
	shape.map_data = mapdata

	$Shape.shape = shape
