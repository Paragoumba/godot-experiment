extends CenterContainer

func _process(_delta):
	var player = $/root/Root/Player
	var playerPos = player.position
	var world = $/root/Root/World
	var worldPos = world.position
	var playerMarker = $Player
	var worldMeshSize = $/root/Root/Platform/PlatformMesh.mesh.size
	var sizeInside = size - playerMarker.size

	playerMarker.pivot_offset = playerMarker.size / 2

	playerMarker.position = size / 2 + (Vector2(playerPos.x, playerPos.z) - Vector2(worldPos.x, worldPos.z)) * sizeInside / Vector2(worldMeshSize.x, worldMeshSize.z)
	playerMarker.position.x = max(0, min(sizeInside.x, playerMarker.position.x))
	playerMarker.position.y = max(0, min(sizeInside.y, playerMarker.position.y))
	playerMarker.rotation = -player.rotation.y
