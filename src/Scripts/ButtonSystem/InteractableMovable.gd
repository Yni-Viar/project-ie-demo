extends AnimatableBody3D
class_name InteractableMovable
## Made by Yni, licensed under CC0.
## A AnimatableBody, that can be interacted.

@export var has_sound: bool
@export var sound_path: String

func interact(player: Node3D):
	if has_sound:
		var sfx: AudioStreamPlayer3D = get_node(sound_path)
		sfx.play()

func interact_alt(player: Node3D):
	if has_sound:
		var sfx: AudioStreamPlayer3D = get_node(sound_path)
		sfx.play()
