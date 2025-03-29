extends Control
## Made by Yni, licensed under MIT License.

var special_screen: Array = [false, ""]
var speaker_prefab: PhysicsBody3D
var button_busy = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() == "Web" || OS.get_name() == "Android":
		$PauseMenu/Panel/SettingsButton.hide()
		#$PauseMenu/Panel/ExitButton.hide()
		#$GameOverPanel/MenuButton.hide()
	if Settings.touchscreen:
		$TouchUI.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if special_screen[0]:
		$Cursor.hide()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		$Cursor.show()
		if !Settings.touchscreen:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		input_values("exitgame")
		button_busy = false
	#if Input.is_action_just_pressed("console"):
		#input_values("console")
	if Input.is_action_just_pressed("human_inventory"):
		input_values("inventory")
		button_busy = false
	if Input.is_action_just_pressed("save_screenshot"):
		input_values("screenshot")
		button_busy = false

func input_values(state: String):
	button_busy = true
	match state:
		"exitgame":
			if special_screen[1] != "exitgame":
				$PauseMenu.show()
				if special_screen[1].is_empty():
					special_screen[0] = true
					special_screen[1] = "exitgame"
			else:
				$PauseMenu.hide()
				if $Settings.visible:
					input_values("settings_close")
				if $PhotomodeSelector.visible:
					input_values("photomode_close")
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
			button_busy = false
			if special_screen[1] == "settings":
				special_screen[0] = false
				special_screen[1] = ""
		"photomode":
			if special_screen[1] != "photomode":
				$PhotomodeSelector.show()
				if special_screen[1].is_empty():
					special_screen[0] = true
					special_screen[1] = "photomode"
		"photomode_close":
			$PhotomodeSelector.hide()
			if special_screen[1] == "photomode":
				special_screen[0] = false
				special_screen[1] = ""
		"screenshot":
			#saving in Web... I think, it is unsafe.
			#saving in Android is useless, since no one except this app can read these screenshots...
			if OS.get_name() != "Web" || OS.get_name() != "Android":
				var time: String = Time.get_datetime_string_from_system().replace(":", "-")
				var image = get_viewport().get_texture().get_image()
				var path: String = "user://" + time + ".png"
				image.save_png(path)

func speak(dlg_path: String, dlg_start_id: String, speaker_nodepath: String):
	if !$DialogueBox.is_running():
		$DialogueBox.data = load(dlg_path)
		speaker_prefab = get_node(speaker_nodepath)
		var player: PlayerScript = get_tree().root.get_node("Game/Player")
		player.look_at(Vector3(speaker_prefab.global_position.x, player.global_position.y, speaker_prefab.global_position.z))

		if speaker_prefab is MovableNpc:# New Godot 4.4 code for looking at player.
			speaker_prefab.get_node(str(speaker_prefab.skeleton_path) + "/LookAtModifier3D").target_node = NodePath(player.get_node("LookAtTarget").get_path())
		elif speaker_prefab is StaticNpc:# Old Godot 4.3 code for looking at player.
			speaker_prefab.look_at(Vector3(player.global_position.x, speaker_prefab.global_position.y, player.global_position.z))
		if special_screen[1].is_empty():
			special_screen[0] = true
			special_screen[1] = "dialogue"
		if Settings.touchscreen:
			$TouchUI.hide()
		$DialogueBox.start(dlg_start_id)
		$DialogueBox.show()
		player.motion_enabled = false
		player.set_physics_process(false)


func _on_dialogue_box_dialogue_ended() -> void:
	if special_screen[1] == "dialogue":
		special_screen[0] = false
		special_screen[1] = ""
	# New Godot 4.4 code
	if speaker_prefab is MovableNpc:
		if speaker_prefab.follow_target.is_empty():
			speaker_prefab.get_node(str(speaker_prefab.skeleton_path) + "/LookAtModifier3D").target_node = NodePath("")
	speaker_prefab = null
	if Settings.touchscreen:
		$TouchUI.show()
	var player: PlayerScript = get_tree().root.get_node("Game/Player")
	player.motion_enabled = true
	player.set_physics_process(true)


func _on_dialogue_box_dialogue_signal(value: String) -> void:
	# Generic interactions
	match value:
		"follow_player":
			if speaker_prefab is MovableNpc:
				speaker_prefab.follow_target = "/root/Game/Player"
				speaker_prefab.wandering = false
		"stop_moving":
			if speaker_prefab is MovableNpc:
				speaker_prefab.follow_target = ""
				speaker_prefab.wandering = false
		"wander":
			if speaker_prefab is MovableNpc:
				speaker_prefab.follow_target = ""
				speaker_prefab.wandering = true
		"stop_talk":
			if speaker_prefab is MovableNpc || speaker_prefab is StaticNpc:
				speaker_prefab.can_talk = false
		"next_talk_pos":
			if speaker_prefab is MovableNpc || speaker_prefab is StaticNpc:
				speaker_prefab.current_dialogue += 1
	if value.contains("change_talk_pos"):
		var splitted_value = int(value.get_slice("|", 1))
		speaker_prefab.current_dialogue = splitted_value



func _on_photomode_button_button_down() -> void:
	if !button_busy:
		if !$PhotomodeSelector.visible:
			input_values("photomode")
		else:
			input_values("photomode_close")


func _on_photomode_button_button_up() -> void:
	button_busy = false


func _on_settings_button_button_down() -> void:
	if !button_busy:
		input_values("settings")


func _on_exit_button_button_down() -> void:
	get_tree().root.get_node("Game").quit()


func _on_back_button_down() -> void:
	if !button_busy:
		input_values("exitgame")


func _on_back_button_up() -> void:
	button_busy = false
