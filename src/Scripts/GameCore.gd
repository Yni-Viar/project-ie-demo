extends Node3D
## Made by Yni, licensed under MIT License.

## Game data.
@export var game_data: GameData
## Current ambient.
@export var current_ambient: String = ""
## Current location.
@export var current_loc = "Loc_Home"
# Unused in this demo.
#var loading_location = false
#var file_path_to_load: String = ""
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings()
	load_save()
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if loading_location:
		#var progress: Array
		#var status = ResourceLoader.load_threaded_get_status(file_path_to_load, progress)
		#if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			#$PlayerUI/LoadingNewLocation/LoadProgress.value = progress[0] * 100
		#if status == ResourceLoader.THREAD_LOAD_LOADED:
			#$PlayerUI/LoadingNewLocation/LoadProgress.value = 0
			#$PlayerUI/LoadingNewLocation.hide()
			#loading_location = false
			#var chunk: Node = ResourceLoader.load_threaded_get(file_path_to_load).instantiate()
			#add_child(chunk, true)

## Part of the unfinished save system.
func load_save():
	var player: CharacterBody3D = ResourceLoader.load("res://FPSController/PlayerScene.tscn").instantiate()
	if game_data.position == Vector3(0, 0, 0):
		player.position = get_node(current_loc + "/SavePoint").global_position
	else:
		player.position = game_data.position
	add_child(player)

## Game over system.
func game_over(id: int):
	for node in get_tree().get_nodes_in_group("Players"):
		#node.set_physics_process(false)
		node.queue_free()
	var game_over_screen: GameOverResource = load("res://Assets/GameOver/" + str(id) + ".tres")
	
	$PlayerUI/GameOverPanel/TextureRect.texture = game_over_screen.screen
	$PlayerUI/GameOverPanel/ODeath.text = game_over_screen.text
	$PlayerUI/GameOverPanel/Reason.text = game_over_screen.reason
	$PlayerUI/GameOverPanel.show()
	$PlayerUI.special_screen = true

## Exits the game.
func quit():
	Settings.first_start = true
	#var loading_screen: Node = load("res://Scenes/HubLoadingScreen.tscn").instantiate()
	#loading_screen.get_node("MainPanel").previous_path = "Game"
	#add_child(loading_screen)
	#loading_screen.get_node("MainPanel").load_game()
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

## Background ambient changer. Unused, since there is no ambient in-game.
func set_background_music(to: String):
	if current_ambient != to:
		$AnimationPlayer.play("music_change")
		$BackgroundMusic.stream = load(to)
		$BackgroundMusic.playing = true
		$AnimationPlayer.play_backwards("music_change")
		current_ambient = to

## Changes environment.
func change_background(env: Environment):
	$WorldEnvironment.environment = env

## Load settings.
func load_settings():
	if RenderingServer.get_current_rendering_method() == "forward_plus":
		# SSAO for Mobile and Compatibility renderer is called in PlayerScript.
		$WorldEnvironment.environment.ssao_enabled = Settings.setting_res.ssao
		$WorldEnvironment.environment.ssil_enabled = Settings.setting_res.ssil
		$WorldEnvironment.environment.ssr_enabled = Settings.setting_res.ssr
		$WorldEnvironment.environment.sdfgi_enabled = Settings.setting_res.dynamic_gi
	$WorldEnvironment.environment.glow_enabled = Settings.setting_res.glow
	## Enable/disable reflection probes (cubemap)
	for node in get_tree().get_nodes_in_group("reflection_probe"):
		if node is ReflectionProbe:
			if !Settings.setting_res.reflection_probes: # || Settings.setting_res.ssr:
				node.hide()
			else:
				node.show()
	
	#for node in get_tree().get_nodes_in_group("voxelgi"):
		#if node is VoxelGI:
			#if !Settings.setting_res.dynamic_gi:
				#node.hide()
			#else:
				#node.show()
	

#func load_location(load: String):
	#if OS.get_name() != "Web":
		#file_path_to_load = load
		#loading_location = true
		#ResourceLoader.load_threaded_request(file_path_to_load)
		#$PlayerUI/LoadingNewLocation.show()
