extends Control
## Made by Yni, licensed under MIT License.

var play_info_toggle: bool
# Called when the node enters the scene tree for the first time.
func _ready():
	# Release the mouse!
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# If NOT Web platform - check for touchscreen.
	if OS.get_name() != "Web":
		Settings.touchscreen = DisplayServer.is_touchscreen_available()
	# Set the background
	match Settings.CURRENT_STAGE:
		Settings.Stages.release:
			get_node("Background").texture = load("res://Assets/Menu/MainMenuBackground.png")
		Settings.Stages.testing:
			get_node("Background").texture = load("res://Assets/Menu/MainMenuBackgroundTesting.png")
		_:
			get_node("Background").texture = load("res://Assets/Menu/MainMenuBackgroundIndev.png")
	
	#get_window().size = Settings.setting_res.window_size[Settings.setting_res.ui_window_size]
	# Set the region (needed for obeying contries' laws)
	Settings.region = OS.get_locale()
	
	# Settings
	AudioServer.set_bus_volume_db(0, linear_to_db(Settings.setting_res.sound))
	if Settings.setting_res.sound < 0.01:
		AudioServer.set_bus_mute(0, true)
	elif Settings.setting_res.sound >= 0.01 && AudioServer.is_bus_mute(0):
		AudioServer.set_bus_mute(0, false)
	
	AudioServer.set_bus_volume_db(1, linear_to_db(Settings.setting_res.music))
	if Settings.setting_res.sound < 0.01:
		AudioServer.set_bus_mute(1, true)
	elif Settings.setting_res.sound >= 0.01 && AudioServer.is_bus_mute(1):
		AudioServer.set_bus_mute(1, false)
	
	# Hide the Exit and Settings buttons on the Web
	if OS.get_name() == "Web":
		$Title/Exit.hide()
		$Title/Settings.hide()
	
	#TranslationServer.set_locale(Settings.setting_res.available_languages[Settings.setting_res.ui_language])
	Settings.first_start = false
	
	
	# Display game ratings in main menu in some countries, this will replace the game logo.
	if Settings.legal_req:
		match Settings.region:
			"ru_RU":
				# New upcoming Russian law.
				$Logo.texture = load("res://Assets/Menu/LawRegulation/RU.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_play_pressed():
	get_parent().get_parent().play()


func _on_settings_pressed():
	$Settings.show()


func _on_credits_pressed():
	$CreditsPanel.show()


func _on_exit_pressed():
	get_tree().quit()


func _on_credits_back_pressed():
	$CreditsPanel.hide()
