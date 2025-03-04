extends Node

enum Stages {release, testing, dev}
enum ItemType {item, map_object, npc}

signal settings_saved

## Migrated from Globals.
## Game's data compatibility for modding.
const DATA_COMPATIBILITY: String = "0.0.1"
## Migrated from Globals.
## Game's data compatibility for modding.
const CURRENT_STAGE: Stages = Stages.dev
## If we don't specify regions, which have additional legal requirements, we are in trouble.
const LEGAL_REQ_REGIONS: PackedStringArray = ["ru_RU"]
## Available languages
var available_languages: Array[String] = ["en", "ru"]
## Necessary for overriding Godot bug.
## Checks when settings would be loaded.
var first_start: bool = true
## Touchscreen check
var touchscreen = false
## Settings resource
var setting_res: SettingsResource
## Default windows sizes.
var window_size: Array[Vector2i] = [Vector2i(1920, 1080), Vector2i(1600, 900), Vector2i(1366, 768),
						Vector2i(1280, 720), Vector2i(1024, 768), Vector2i(800, 600)]
## Current graphic device. 0 is not set, 1 is OpenGL (ES) 3, 2 is RenderingDevice (Vulkan, D3D12 (Windows))
var current_graphic_device: int = 0
## If we don't specify regions, which have additional legal requirements, we are in trouble.
var region: String = "":
	set(val):
		region = val
		legal_req = is_legal_req()
var legal_req: bool = false

func _init():
	load_resource()
	# Add custom windows sizes.
	for v in setting_res.window_size:
		window_size.append(v)

## Sometimes ago it was a great function. Now it is just a stub, that calls ResourceStorage and loads settings
func load_resource():
	if OS.get_name() != "Web":
		var settings_from_file = ResourceStorage.load_resource("user://Settings.bin", "SettingsResource")
		if settings_from_file != null:
			setting_res = settings_from_file
		else:
			load_default_settings()
	else:
		load_default_settings()

func load_default_settings():
	if RenderingServer.get_rendering_device() != null:
		var res = load("res://Scripts/SettingsResource/Presets/RD/Medium.tres")
		save_resource(res)
		setting_res = res
	elif OS.get_name() != "Web" && OS.get_name() != "Android":
		var res = load("res://Scripts/SettingsResource/Presets/OpenGL/Low.tres")
		save_resource(res)
		setting_res = res
	else:
		var res = load("res://Scripts/SettingsResource/Presets/OpenGL/Lowest.tres")
		save_resource(res)
		setting_res = res

## Sometimes ago it was a great function. Now it is just a stub, that calls ResourceStorage and saves settings
func save_resource(res):
	if OS.get_name() != "Web":
		ResourceStorage.save_resource("user://Settings.bin", res)
		emit_signal("settings_saved")

func is_legal_req() -> bool:
	return LEGAL_REQ_REGIONS.has(region)
