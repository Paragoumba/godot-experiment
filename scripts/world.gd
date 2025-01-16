extends Node3D

@export var random: bool

var seedVerb: String = "éê✎😬"
var seed: int
var noise: Noise = FastNoiseLite.new()

func _ready() -> void:
	#noise.set_noise_type(FastNoiseLite.NoiseType.TYPE_CELLULAR)
	
	if random:
		seed = Time.get_ticks_msec() # TODO Not random
	else:
		seed = computeSeed(seedVerb)
	
	noise.set_seed(seed)
	
	for c in get_children():
		c.generate(noise)

func computeSeed(v: String):
	var buffer: PackedByteArray = v.to_utf16_buffer()
	var buffer2: PackedInt32Array = PackedInt32Array()
	var temp = 0
	
	for i in range(0, buffer.size(), 2):
		buffer2.append(buffer[i] | buffer[i + 1] << 8)
		@warning_ignore("integer_division")
		temp = 31 * temp + buffer2[i / 2]
	
	return temp
