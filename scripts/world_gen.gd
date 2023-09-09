extends Node3D

@export var block: PackedScene
var width = 10
var height = 10

func _ready():
	var noise = FastNoiseLite.new()
	var image = noise.get_image(width, height, false, false, false)
	
	for x in image.get_width():
		for y in image.get_height():
			var b = block.instantiate()
		
			b.position = Vector3(x - width / 2, noise.get_noise_2d(x, y) + 1, y - height / 2)
		
			add_child(b)
