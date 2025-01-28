extends BaseTrigger
class_name ShowObject

@export var path: String

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerScript:
		if (graphic_device == 0 && Settings.current_graphic_device == 1) || (graphic_device == 1 && Settings.current_graphic_device == 2) || graphic_device == 2:
			var node_3d: Node3D = get_tree().root.get_node(path)
			if !node_3d.visible:
				node_3d.show()
