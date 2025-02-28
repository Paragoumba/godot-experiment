extends TextureRect

func _ready():
	$/root/Root/World.world_generated.connect(handle_world_generated)

func handle_world_generated(image: Image):
	texture = ImageTexture.create_from_image(image)
