extends Node3D
class_name DoorBase

@export var can_open: bool = true
@export var is_opened: bool = false
@export var can_manual_open: bool = true
@export var enable_sound: bool = true
@export var open_door_sounds: Array[String]
@export var close_door_sounds: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_opened:
		door_open()
	if Settings.setting_res.game_optimizator <= 1:
		set_process(false)
		set_physics_process(false)


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

## Main control method, which checks - is the door opened.
func door_control(player_path: String, keycard: int, check_key: bool = false, manual: bool = false):
	if can_open && (manual && can_manual_open != !manual):
		if (check_key && check_keycard(player_path, keycard)) != !check_key:
			door_controller(keycard)
	#else:
		#$DoorSound.stream = load()

## If DoorControl check is successful, open the door (or close)
func door_controller(keycard: int):
	if is_opened && !get_node("AnimationPlayer").is_playing():
		door_close()
	elif !get_node("AnimationPlayer").is_playing():
		door_open()

## Open the door
func door_open():
	var rng = RandomNumberGenerator.new()
	$AnimationPlayer.play("door_open")
	if !open_door_sounds.is_empty():
		$DoorSound.stream = load(open_door_sounds[rng.randi_range(0, open_door_sounds.size() - 1)])
		$DoorSound.play()
	is_opened = true
## Closes the door
func door_close():
	var rng = RandomNumberGenerator.new()
	$AnimationPlayer.play("door_open", -1, -1, true)
	if !close_door_sounds.is_empty():
		$DoorSound.stream = load(close_door_sounds[rng.randi_range(0, close_door_sounds.size() - 1)])
		$DoorSound.play()
	is_opened = false

func check_keycard(player_path: String, keycard: int) -> bool:
	var player = get_node(player_path)
	if player is PlayerScript:
		if player.keycards.has(keycard):
			return true
		else:
			return false
	else:
		return false
