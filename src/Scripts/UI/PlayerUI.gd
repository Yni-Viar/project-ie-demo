extends Control

var special_screen: Array = [false, ""]
var speaker_prefab: InteractableNpc

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() == "Web":
		$PauseMenu/Panel/SettingsButton.hide()
		#$PauseMenu/Panel/ExitButton.hide()
		#$GameOverPanel/MenuButton.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if special_screen[0]:
		$Cursor.hide()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		$Cursor.show()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		input_values("exitgame")
	#if Input.is_action_just_pressed("console"):
		#input_values("console")
	if Input.is_action_just_pressed("human_inventory"):
		input_values("inventory")

func input_values(state: String):
	match state:
		#"console":
			#if !special_screen:
				#get_tree().root.get_node("Game/InGameConsole").visible = true
				#special_screen = true
			#else:
				#get_tree().root.get_node("Game/InGameConsole").visible = false
				#special_screen = false
			
			# See: https://softwareengineering.stackexchange.com/questions/147111/what-is-wrong-with-the-unlicense
			# The ingame terminal was licensed under this license
		"exitgame":
			if special_screen[1] != "exitgame":
				$PauseMenu.show()
				if special_screen[1].is_empty():
					special_screen[0] = true
					special_screen[1] = "exitgame"
			else:
				$PauseMenu.hide()
				if special_screen[1] == "exitgame":
					special_screen[0] = false
					special_screen[1] = ""
		"inventory":
			if special_screen[1] != "inventory":
				get_tree().root.get_node("Game/Player/InventoryUI").show()
				if special_screen[1].is_empty():
					special_screen[0] = true
					special_screen[1] = "inventory"
			else:
				get_tree().root.get_node("Game/Player/InventoryUI").hide()
				if special_screen[1] == "inventory":
					special_screen[0] = false
					special_screen[1] = ""
		"settings":
			if special_screen[1] != "settings":
				$Settings.show()
				if special_screen[1].is_empty():
					special_screen[0] = true
					special_screen[1] = "settings"
		"settings_close":
			$Settings.hide()
			if special_screen[1] == "settings":
				special_screen[0] = false
				special_screen[1] = ""


func _on_exit_button_pressed():
	get_tree().root.get_node("Game").quit()


func speak(dlg_path: String, dlg_start_id: String, speaker_nodepath: String):
	if !$DialogueBox.is_running():
		$DialogueBox.data = load(dlg_path)
		speaker_prefab = get_node(speaker_nodepath)
		# Wait until 4.4 face IK solution :-D
		var player: PlayerScript = get_tree().root.get_node("Game/Player")
		player.look_at(Vector3(speaker_prefab.global_position.x, player.global_position.y, speaker_prefab.global_position.z))
		speaker_prefab.look_at(Vector3(player.global_position.x, speaker_prefab.global_position.y, player.global_position.z))
		if special_screen[1].is_empty():
			special_screen[0] = true
			special_screen[1] = "dialogue"
		$DialogueBox.start(dlg_start_id)
		$DialogueBox.show()
		player.motion_enabled = false
		player.set_physics_process(false)


func _on_dialogue_box_dialogue_ended() -> void:
	if special_screen[1] == "dialogue":
		special_screen[0] = false
		special_screen[1] = ""
	speaker_prefab = null
	var player: PlayerScript = get_tree().root.get_node("Game/Player")
	player.motion_enabled = true
	player.set_physics_process(true)


func _on_dialogue_box_dialogue_signal(value: String) -> void:
	# Generic interactions
	match value:
		"follow_player":
			speaker_prefab.follow_target = "/root/Game/Player"
			speaker_prefab.wandering = false
		"stop_moving":
			speaker_prefab.follow_target = ""
			speaker_prefab.wandering = false
		"wander":
			speaker_prefab.follow_target = ""
			speaker_prefab.wandering = true
		"stop_talk":
			speaker_prefab.can_talk = false
		"next_talk_pos":
			speaker_prefab.current_dialogue += 1
	if value.contains("change_talk_pos"):
		var splitted_value = int(value.get_slice("|", 1))
		speaker_prefab.current_dialogue = splitted_value


func _on_settings_button_pressed() -> void:
	input_values("settings")
