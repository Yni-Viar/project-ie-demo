extends Area3D
class_name BaseTrigger
## Made by Yni, licensed under CC0.
## Trigger base function.

enum GraphicDevice {OPENGL3, RD, BOTH}
@export var graphic_device: GraphicDevice = GraphicDevice.BOTH

func _ready() -> void:
	if Settings.setting_res.game_optimizator <= 1:
		set_process(false)
		set_physics_process(false)
