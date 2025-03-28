extends Node
class_name AppManager
## Made by Yni, licensed under CC0.
## This script is remnant of TGPY and SCP: Site Online.

## Called when the node enters the scene tree for the first time.
#func _ready():
	#RenderingServer.frame_post_draw.connect(end_shader_compilation)
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
## Start the game!
func play():
	$CanvasLayer/Loading.show()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/GameDemo.tscn")
#
#func end_shader_compilation():
	#var tex_to_shader_compile: ViewportTexture = ViewportTexture.new()
	#tex_to_shader_compile.viewport_path = NodePath("SubViewport")
	#$CanvasLayer/TestRectangle.texture = tex_to_shader_compile
	#RenderingServer.frame_post_draw.disconnect(end_shader_compilation)
	#$CanvasLayer/Loading.hide()
	#$CanvasLayer/Loading.text = "LOAD_TITLE"
	#$CanvasLayer/TestRectangle.queue_free()
	#$SubViewport.queue_free()
