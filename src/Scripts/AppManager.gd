extends Node
class_name AppManager
## Made by Yni, licensed under CC0.
## This script is remnant of TGPY and SCP: Site Online.

## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
## Start the game!
func play():
	get_tree().change_scene_to_file("res://Scenes/GameDemo.tscn")
