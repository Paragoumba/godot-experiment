extends Node

func print_child(depth: int, parent: Node):
	var path = parent.get_path_to(parent)
	print('-'.repeat(depth), parent, path, parent.get_node(path) == parent)

	for child in parent.get_children():
		print_child(depth + 1, child)
