extends StaticBody3D
class_name PathWalkerHelper


# Called when the node enters the scene tree for the first time.
func _ready():
	if Settings.setting_res.game_optimizator <= 1:
		set_process(false)
		set_physics_process(false)

func interact():
	get_parent().interact()
