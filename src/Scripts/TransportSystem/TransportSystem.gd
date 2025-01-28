extends PathFollow3D
## Transport system
## Made by Yni, licensed under BSD-2 with Patent Exception license
class_name TransportSystem

## Launch or stop
signal changed_launch_state(start: bool)
## Lock or unlock moving
signal changed_lock_state(start: bool)
enum TransportType {CABLECAR, TRAIN}
# Transport type (currently unused)
#@export var transport_type: TransportType = TransportType.CABLECAR
## Only head wagons can move by themselves
@export var is_headwagon: bool = true
## Will be the transport locked on start
@export var locked: bool = false
## Max speed
@export var speed: float = 3
## Moving state (if you are making networked game, sync this value)
@export var is_moving: bool = false
## Move sound
@export var move_sound: String = ""
## Door open sounds
@export var open_door_sounds : Array[String] = []
## Door close sounds
@export var close_door_sounds : Array[String] = []
# Previously, in TGPY game, this variable was used for aligning
# player position to transport position. This had not so good drawbacks in trains
## Since v2, it holds smooth rotation, while transport moves along the curve
@export var objects_to_teleport : Array
## Necessary!!! Needs to update AnimationMesh position
@export var animatable_path: NodePath
## Necessary!!! Keys are used only in head wagon, values used both by head and other wagons.
## This is how stops are made.
@export var waypoints : Dictionary = {}
## If true - opens the right door, else opens left door
@export var which_door_open_on_start: bool = true
## Connected wagons. Connected wagons must have is_headwagon property DISABLED!
@export var connected_wagons: Array[NodePath]
## Connected wagon offset
@export var wagon_offset: float
## The ACTUAL speed (if you are making networked game, sync this value)
@export var sample_speed = 0.1
var _move_sounds: Array[AudioStream] = []
var left_door_open: bool = false
var right_door_open: bool = false
## Next stop
var last_move = 0
## Checks, if the train have already reached the end.
## In this case, "the end" means the train passed the last "station" on this curve/waypoint
var at_end: bool = false
## Wagons database
var wagons: Array[TransportSystem]
## For checking difference between rotation
var rotator: PackedVector3Array
## Current_move_sound
var current_move_sound: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	if ResourceLoader.exists(move_sound):
		$Move.stream = load(move_sound)
	rotator.append(global_rotation)
	if connected_wagons.size() > 0 && is_headwagon:
		for i in range(connected_wagons.size()):
			# Applying offset and create initial rotation
			if i == 0:
				get_node(connected_wagons[0]).progress = progress - wagon_offset
			else:
				get_node(connected_wagons[i]).progress = get_node(connected_wagons[i - 1]).progress - wagon_offset
			wagons.append(get_node(connected_wagons[i]))
			rotator.append(wagons[i].global_rotation)
	if !is_moving:
		stop()

 # Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if waypoints != null:
		if is_moving && waypoints.size() > 0:
			if is_headwagon:
				if at_end:
					# If at end, check if progress reaches the start point of the curve
					if progress + 1 < speed:
						at_end = false
						progress = 0
					if wagons.size() > 0:
						for i in range(wagons.size()):
							if wagons[i].progress + 1 < speed:
								wagons[i].at_end = false
								wagons[i].progress = 0
				else:
					# stop at the "station"
					if progress > waypoints.keys()[last_move] - speed * 8:
						sample_speed = move_toward(sample_speed, 0.1, 0.5 * delta)
					if progress + 0.001 >= waypoints.keys()[last_move]:
						stop()
						if wagons.size() > 0:
							for i in range(wagons.size()):
								wagons[i].call("stop")
				# That is how train moves
				progress += sample_speed * delta
				# Move the mesh (AnimationBody3D do not move automatically)
				get_node(animatable_path).global_position = global_position
				if sample_speed < speed:
					if progress < waypoints.keys()[last_move] - speed * 8:
						# Increase the speed
						sample_speed = move_toward(sample_speed, speed, 0.5 * delta)
				if wagons.size() > 0:
					# Move of the wagons and move wagons mesh
					for i in range(wagons.size()):
						wagons[i].progress += sample_speed * delta
						wagons[i].get_node(animatable_path).global_position = wagons[i].global_position
				# Smooth rotation for player(s) (and item(s))
				for w in wagons.size():
					for i in range(wagons[w].objects_to_teleport.size()):
						var node: Node3D = get_node(wagons[w].objects_to_teleport[i])
						node.global_rotation = node.global_rotation + (wagons[w].global_rotation - rotator[w + 1])
						rotator[w + 1] = wagons[w].global_rotation
				for i in range(objects_to_teleport.size()):
					var node: Node3D = get_node(objects_to_teleport[i])
					node.global_rotation = node.global_rotation + (global_rotation - rotator[0])
					rotator[0] = global_rotation
		# Increase pitch when change speed
		if sample_speed < speed:
			if progress < waypoints.keys()[last_move] - speed * 8:
				if $Move.pitch_scale < 1:
					$Move.pitch_scale += 0.0625 * delta
		elif !at_end && progress > waypoints.keys()[last_move] - speed * 8:
			if $Move.pitch_scale > 0.5:
				$Move.pitch_scale -= 0.0625 * delta

## Stop the transport
func stop():
	$Move.pitch_scale = 0.5
	$Move.stop()
	changed_launch_state.emit(false)
	call("open_dest_doors", waypoints[waypoints.keys()[last_move]])
	is_moving = false
	await get_tree().create_timer(10.0).timeout
	if !locked:
		transport_move(true)

## Open the door
func door_open(left_or_right: bool):
	var rng = RandomNumberGenerator.new()
	if left_or_right:
		$AnimationPlayer.play("door_open_right")
		right_door_open = true
	else:
		$AnimationPlayer.play("door_open_left")
		left_door_open = true
	set_physics_process(false)
	if !open_door_sounds.is_empty():
		for node in $DoorSounds.get_children():
			if node is AudioStreamPlayer3D:
				node.stream = load(open_door_sounds[rng.randi_range(0, open_door_sounds.size() - 1)])
				node.play()
## Closes the door
func door_close():
	var rng = RandomNumberGenerator.new()
	if left_door_open:
		$AnimationPlayer.play_backwards("door_open_left")
		left_door_open = false
	if right_door_open:
		$AnimationPlayer.play_backwards("door_open_right")
		right_door_open = false
	$AnimationPlayer.connect("animation_finished", _on_animation_finished)
	if !close_door_sounds.is_empty():
		for node in $DoorSounds.get_children():
			if node is AudioStreamPlayer3D:
				node.stream = load(close_door_sounds[rng.randi_range(0, close_door_sounds.size() - 1)])
				node.play()

## Moves transport (network method)
func transport_move(close_door : bool):
	if close_door:
		door_close()
	changed_launch_state.emit(true)
	is_moving = true
	if last_move < waypoints.size():
		last_move += 1
		if last_move == waypoints.size():
			last_move = 0
			at_end = true
			if wagons.size() > 0:
				for i in range(wagons.size()):
					wagons[i].last_move = 0
					wagons[i].at_end = true
	$Move.play()

## Opens destination doors. Right is true, left is false.
func open_dest_doors(left_or_right: bool):
	door_open(left_or_right)

func on_player_area_body_entered(body):
	if body is CharacterBody3D: #|| body is Pickable:
		call("add_object", body.get_path())

func on_player_area_body_exited(body):
	if body is CharacterBody3D: # || body is Pickable:
		call("remove_object", body.get_path())

func add_object(name):
	objects_to_teleport.append(name)

func remove_object(name):
	objects_to_teleport.erase(name)

## Lock management (borrowed from TGPY)
func interact():
	locked = !locked
	if locked == false:
		await get_tree().create_timer(10.0).timeout
		transport_move(true)

func _on_animation_finished(anim_name):
	$AnimationPlayer.disconnect("animation_finished", _on_animation_finished)
	set_physics_process(true)
