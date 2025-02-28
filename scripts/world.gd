extends Node3D

signal world_generated

@onready var normal_shader: Shader = preload("res://shaders/normals.gdshader")

@export var random: bool
@export var block: PackedScene

var width: int = 50
var height: int = 50
var blockScale: float = 0.25
var amplification = 20

var seedVerb: String = "éê✎😬"
var seedValue: int
var noise: Noise = FastNoiseLite.new()

var chunks: Dictionary = {}

func _ready() -> void:
	#noise.set_noise_type(FastNoiseLite.NoiseType.TYPE_CELLULAR)

	if random:
		seedValue = Time.get_ticks_msec() # TODO Not random
	else:
		seedValue = computeSeed(seedVerb)

	noise.set_seed(seedValue)

	for c in get_children():
		generate(c)

	for i in range(-2, 3):
		for j in range(-2, 3):
			if (abs(i) == 2 || abs(j) == 2):
				loadChunk(Vector2(i, j))

func computeSeed(v: String):
	var buffer: PackedByteArray = v.to_utf16_buffer()
	var buffer2: PackedInt32Array = PackedInt32Array()
	var temp = 0

	for i in range(0, buffer.size(), 2):
		buffer2.append(buffer[i] | buffer[i + 1] << 8)
		@warning_ignore("integer_division")
		temp = 31 * temp + buffer2[i / 2]

	return temp

func get_chunk_name(pos: Vector2):
	return str(pos)

func check_chunk_exists(pos: Vector2):
	return get_chunk_name(pos) in chunks

func loadChunk(pos: Vector2i):
	if !check_chunk_exists(pos):
		var chunk = Chunk.new()

		chunk.name = get_chunk_name(pos)

		chunk.cx = pos.x
		chunk.cz = pos.y

		chunk.position = Vector3(pos.x * width, 0, pos.y * height)

		self.add_child(chunk)

		generate(chunk)

		chunks[chunk.name] = chunk
	else:
		print("Chunk already loaded")

func generate(chunk: Chunk):
	gen_surface(chunk)

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
			b.position = Vector3((x - float(width) / 2) * blockScale,
								blockHeight + 0.1,
								(y - float(blockHeight) / 2) * blockScale)

			add_child(b)

func gen_surface(chunk: Chunk):
	print("Generating chunk ", chunk.name)

	var st = SurfaceTool.new()
	var mapdata = PackedFloat32Array()

	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	for z in range(height + 1):
		for x in range(width + 1):
			var absX = chunk.cx * width + x
			var absZ = chunk.cz * height + z

			var y = get_noise_2d(noise, absX, absZ)

			mapdata.append(y)

			if x != 0 && z != 0:
				var v1 = Vector3(x, y, z)
				var v2 = Vector3(x - 1, mapdata[(x - 1) + (z - 1) * (height + 1)], z - 1)
				var v3 = Vector3(x, mapdata[x + (z - 1) * (height + 1)], z - 1)
				var v4 = Vector3(x - 1, mapdata[(x - 1) + z * (height + 1)], z)

				# Triangle 1
				#var normal = (v4 - v1).cross(v1 - v3).normalized()
				# Top left
				#st.set_normal(normal)
				st.set_uv(Vector2(0, 0))
				st.set_color(Color.BLUE)
				st.add_vertex(v1)

				# Bottom right
				#st.set_normal(normal)
				st.set_uv(Vector2(1, 1))
				st.set_color(Color.RED)
				st.add_vertex(v4)

				# Top right
				#st.set_normal(normal)
				st.set_uv(Vector2(0, 1))
				st.set_color(Color.GREEN)
				st.add_vertex(v3)

				# Triangle 2
				#normal = (v3 - v4).cross(v2 - v4).normalized()
				# Top left
				#st.set_normal(normal)
				st.set_uv(Vector2(0, 0))
				st.set_color(Color.BLUE)
				st.add_vertex(v4)

				# Bottom right
				#st.set_normal(normal)
				st.set_uv(Vector2(1, 1))
				st.set_color(Color.RED)
				st.add_vertex(v2)

				# Top right
				#st.set_normal(normal)
				st.set_uv(Vector2(0, 1))
				st.set_color(Color.GREEN)
				st.add_vertex(v3)

	st.generate_normals()

	# Commit to a mesh.
	var mesh: ArrayMesh = st.commit()
	var material: ShaderMaterial = ShaderMaterial.new()

	material.shader = normal_shader
	mesh.surface_set_material(0, material)
	chunk.get_node("Mesh").mesh = mesh

	var shape: HeightMapShape3D = HeightMapShape3D.new()

	shape.map_width = width + 1
	shape.map_depth = height + 1
	shape.map_data = mapdata

	chunk.get_node("Shape").shape = shape

func _on_player_changed_chunk(pos: Vector3) -> void:
	loadChunk(Vector2i(pos.x / width, pos.z / height))
