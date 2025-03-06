extends Container

@export_range(1, 360, 0.1, "radians_as_degrees") var FOV: float = PI / 3
@export var labelSettings: LabelSettings

var player: Node3D
var line: Line2D
var northLine: Line2D
var northLabel: Label

func _ready() -> void:
	player = $/root/Root/Player

	line = $Line2D

	northLine = Line2D.new()
	northLabel = Label.new()

	northLabel.label_settings = labelSettings
	northLabel.text = "North"

	northLine.width = line.width
	northLine.add_point(Vector2(0, 0))
	northLine.add_point(Vector2(0, 10))

	northLine.add_child(northLabel)
	add_child(northLine)

func _process(_delta: float) -> void:
	var length = size.x
	var centerX = length / 2

	line.points[2].x = length
	line.points[1].x = centerX

	var northX = centerX + (player.rotation.y / FOV) * length

	northLine.points[0].x = northX
	northLine.points[1].x = northX
	northLabel.position.x = northX - northLabel.size.x / 2
	northLabel.position.y = 10
