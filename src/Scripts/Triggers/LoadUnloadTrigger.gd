extends BaseTrigger
## Loads or unloads locations (and more).
class_name LoadUnloadTrigger

## Load is true
## Unload is false
## Roses are blue
## Godot is not horse :) -Yni
@export var load = true
@export var file_path_to_load: String
@export var scene_path_to_unload: String


func _on_body_entered(body: Node3D) -> void:
	if body is PlayerScript:
		if load:
			if get_tree().root.get_node_or_null(scene_path_to_unload) == null && FileAccess.file_exists(file_path_to_load):
				get_tree().root.get_node("Game").load_location(file_path_to_load)
		else:
			if get_tree().root.get_node_or_null(scene_path_to_unload) != null:
				get_tree().root.get_node(scene_path_to_unload).queue_free()
