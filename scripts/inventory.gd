extends GridContainer

@export var slot_scene: PackedScene

func _ready():
	for i in 16:
		var slot = slot_scene.instantiate();
		
		if i == 0:
			slot.get_child(0).visible = true;
		
		#slot.position = Vector2((i * 26) % (8 * 26), i / 8 * 26);
		
		add_child(slot);
