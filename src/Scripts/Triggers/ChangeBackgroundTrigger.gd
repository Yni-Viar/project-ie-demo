extends BaseTrigger

@export var env: Environment


func _on_body_entered(body: Node3D) -> void:
	if body is PlayerScript:
		get_tree().root.get_node("Game").change_background(env)
