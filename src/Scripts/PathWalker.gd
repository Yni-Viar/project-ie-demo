extends PathFollow3D
class_name PathWalker

@export var enable_interact: bool = true
var enabled: bool = true
var transition: bool = false
var counter: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	if Settings.setting_res.game_optimizator <= 0:
		set_process(false)
		set_physics_process(false)

func interact():
	if enable_interact:
		transition = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if enabled:
		progress_ratio += 0.005 * delta
	if transition:
		if enabled:
			progress_ratio += move_toward(0.005, 0, delta) * delta
			$Sound.volume_db = move_toward(0, -10, delta) * delta
			counter += 1
		else:
			progress_ratio += move_toward(0, 0.005, delta) * delta
			$Sound.volume_db = move_toward(-10, 0, delta) * delta
			counter += 1
		if counter == 5:
			enabled = !enabled
			$Sound.playing = !$Sound.playing
			counter = 0
			transition = false
