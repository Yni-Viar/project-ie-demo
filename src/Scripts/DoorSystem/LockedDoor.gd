extends DoorBase

@export var keycard: int

#func door_controller(keycard: int):
	#super.door_controller(keycard)
	#if is_opened && !get_node("AnimationPlayer").is_playing():
		#door_close()
	#elif !get_node("AnimationPlayer").is_playing():
		#door_open()


func _on_area_3d_body_entered(body):
	if body is PlayerScript:
		if (body.keycards.has(keycard) || keycard == -1) && can_open:
			door_open()


func _on_area_3d_body_exited(body):
	if body is PlayerScript:
		if (body.keycards.has(keycard) || keycard == -1) && can_open:
			door_close()
