extends StaticBody3D
class_name StaticNpc

## Can the character speak
@export var can_talk: bool = false
## Dialogues.
## The structure of the array:
## [[path_to_the_dialogue, dialogue_name], ...]
## E.g. [["res://Dialogues/dlg_test.tres", "dlg_test"]]
@export var dialogues: Array[Array]
## Current dialogue
var current_dialogue: int = 0

## Start dialogue with NPC
func interact(must_talk: bool = false):
	if can_talk || must_talk:
		get_tree().root.get_node("Game/PlayerUI").speak(dialogues[current_dialogue][0], dialogues[current_dialogue][1], get_path())
