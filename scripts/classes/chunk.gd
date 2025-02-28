class_name Chunk extends StaticBody3D

@export var cx: int = 0
@export var cz: int = 0

func _ready() -> void:
	var shape = CollisionShape3D.new()
	shape.name = "Shape"

	self.add_child(shape)

	var mesh = MeshInstance3D.new()
	mesh.name = "Mesh"
	mesh.position = Vector3(-25, 0, -25)
	self.add_child(mesh)
