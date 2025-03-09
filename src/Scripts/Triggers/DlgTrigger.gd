extends BaseTrigger
## Made by Yni, licensed under CC0.
## Dialogue trigger. Used only on the ground floor on this demo.

@export var character_path: String
var interacted: bool = false


func _on_body_entered(body: Node3D) -> void:
	if body is InteractableNpc:
		if str(body.get_path()) == character_path && !interacted:
			body.interact(true)
			interacted = true
