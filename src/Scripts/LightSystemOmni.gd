extends OmniLight3D
class_name LightSystemOmni
## Made by Yni, licensed under MIT License.

@export var min_light_energy: float = 0.2
@export var max_light_energy: float = 1
@export var enabled: bool = true:
	set(val):
		if val:
			turn_lights_on()
		else:
			turn_lights_off()
		enabled = val

## turns lights off
func turn_lights_off():
	#light_energy = max_light_energy + 1
	#await get_tree().create_timer(0.2).timeout
	light_energy = 0
## turns lights on
func turn_lights_on():
	light_energy = max_light_energy

func _ready():
	# Hide, if lights are disabled
	if !Settings.setting_res.enable_lights:
		hide()
		set_process(false)
		set_physics_process(false)
	if Settings.setting_res.game_optimizator <= 1:
		set_process(false)
		set_physics_process(false)
	# Disable shadows, if they exist and the relevant setting is off.
	if !Settings.setting_res.enable_light_shadows && shadow_enabled:
		shadow_enabled = false
