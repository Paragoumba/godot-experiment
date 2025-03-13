extends CharacterBody3D

const SPEED = 5
const DISTANCE = 2

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var animationPlayer: AnimationPlayer = $'character-orc'/AnimationPlayer

var astar: AStar3D = AStar3D.new()
var point = Vector3.ZERO

var current_astar_index = 0
var dead = false

func hit():
	if !dead:
		dead = true
		animationPlayer.play("die")

func _ready():
	astar.add_point(0, point)
	astar.add_point(1, point)

func _process(delta):
	if dead:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var path = astar.get_point_path(0, 1)

	if current_astar_index < path.size():
		var target = path[current_astar_index]
		var direction = target - position
		if direction.length() < 1:
			pass
		else:
			#velocity = direction.normalized() * SPEED
			position += direction.normalized() * SPEED * delta

	var playerPos = %Player.position
	var goToRadius = (position - playerPos).normalized() * DISTANCE + playerPos

	point.x = goToRadius.x
	point.z = goToRadius.z

	astar.add_point(0, astar.get_point_position(1))
	astar.add_point(1, point)
	astar.connect_points(0, 1, true)
	#position = astar.get_closest_position_in_segment(position)

	var up = Vector3.UP
	var playerLookAt = playerPos
	playerLookAt.y = position.y
	var lookAtDirection = (playerLookAt - position).normalized()

	if !position.is_equal_approx(playerLookAt) && lookAtDirection.dot(up) != 1:
		look_at(playerLookAt, up)

	move_and_slide()
