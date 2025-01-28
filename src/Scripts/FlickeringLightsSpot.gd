extends LightSystemSpot

var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	flicker_lights()

## Light flicker
func flicker_lights():
	await get_tree().create_timer(rng.randf_range(0.2, 0.6)).timeout
	light_energy = rng.randf_range(min_light_energy, max_light_energy)
