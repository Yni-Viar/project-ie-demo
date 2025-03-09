extends Control
class_name BossBar
## Made by Yni, licensed under CC0.

var id: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	set_physics_process(false)
