extends GridContainer

@export var slot_scene: PackedScene
@export var slot_number: int
@export var spritesheet: String

func _ready():
	var parser = XMLParser.new()
	var error = parser.open(spritesheet)
	
	if error != OK:
		print("Error opening XML file ", error)
		return
		
	parser.read()
	
	for i in slot_number:
		var slot = slot_scene.instantiate();
		
		add_child(slot);
		
		parser.read()
		
		var child = slot.get_node("CenterContainer/ItemTexture")
		var region = child.texture.region
		
		region.position.x = parser.get_named_attribute_value("x").to_int()
		region.position.y = parser.get_named_attribute_value("y").to_int()
		region.size.x = parser.get_named_attribute_value("width").to_int()
		region.size.y = parser.get_named_attribute_value("height").to_int()
		
		child.texture.region = region
		
		#if i == 0:
		#	slot.get_child(0).visible = true;
		
		#slot.position = Vector2((i * 26) % (8 * 26), i / 8 * 26);
