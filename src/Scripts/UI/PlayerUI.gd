extends Control

var special_screen: bool = false
var speaker_prefab: InteractableNpc

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if special_screen:
		$Cursor.hide()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		$Cursor.show()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		input_values("exitgame")
	if Input.is_action_just_pressed("console"):
		input_values("console")
	if Input.is_action_just_pressed("human_inventory"):
		input_values("inventory")

func input_values(state: String):
	match state:
		"console":
			if !special_screen:
				get_tree().root.get_node("Game/InGameConsole").visible = true
				special_screen = true
			else:
				get_tree().root.get_node("Game/InGameConsole").visible = false
				special_screen = false
		"exitgame":
			if !special_screen:
				$PauseMenu.show()
				special_screen = true
			else:
				$PauseMenu.hide()
				special_screen = false
		"inventory":
			if !special_screen:
				get_tree().root.get_node("Game/Player/InventoryUI").show()
				special_screen = true
			else:
				get_tree().root.get_node("Game/Player/InventoryUI").hide()
				special_screen = false


func _on_exit_button_pressed():
	get_tree().root.get_node("Game").quit()


func speak(dlg_path: String, dlg_start_id: String, speaker_nodepath: String):
	if !$DialogueBox.is_running():
		$DialogueBox.data = load(dlg_path)
		speaker_prefab = get_node(speaker_nodepath)
		special_screen = true
		$DialogueBox.start(dlg_start_id)
		$DialogueBox.show()
		get_tree().root.get_node("Game/Player").set_physics_process(false)


func _on_dialogue_box_dialogue_ended() -> void:
	special_screen = false
	speaker_prefab = null
	get_tree().root.get_node("Game/Player").set_physics_process(true)


func _on_dialogue_box_dialogue_signal(value: String) -> void:
	# Generic interactions
	match value:
		"follow_player":
			speaker_prefab.follow_target = "/root/Game/Player"
		"stop_follow":
			speaker_prefab.follow_target = ""
		"stop_talk":
			speaker_prefab.can_talk = false
		"next_talk_pos":
			speaker_prefab.current_dialogue += 1
	if value.contains("change_talk_pos"):
		var splitted_value = int(value.get_slice("|", 1))
		speaker_prefab.current_dialogue = splitted_value


func _on_settings_button_pressed() -> void:
	$Settings.show()
	special_screen = true
