@icon("res://Scripts/ElevatorSystem/elevator_node.svg")
extends Node3D
class_name ElevatorSystem
## Made by Yni, licensed under MIT License.
## Elevator system

## Launch or stop
signal changed_launch_state(start: bool)
enum LastMove {UP, DOWN}
var last_move: LastMove = LastMove.UP
## Elevator floors
@export var floors : Array[ElevatorFloor]
## Elevator's external doors
@export var elevator_doors : PackedStringArray
## Elevator speed
@export var speed: float = 2
## Check if moving, automatic
@export var is_moving: bool = false
## Sounds, that will played, when door is opened.
@export var open_door_sounds : PackedStringArray
## Sounds, that will played, when door is closed.
@export var close_door_sounds : PackedStringArray
## Since v2, it holds smooth rotation, while transport moves along the curve
@export var objects_to_teleport : Array
## Current floor (where are you), automatic
@export var current_floor : int
## Target floor (where are you going), automatic
@export var target_floor : int
## Waypoints (All waypoints to process, automatic)
@export var waypoints : Array[Array]
## Locks the elevator
@export var locked: bool = false
## Use only if you set navigation
@export var navigation_link: NodePath
## Use only if you set navigation
@export var navigation_region: NodePath
var counter: int = 0
var pass_floor: bool = false
var default_rotation: Vector3
## For checking difference between rotation
var rotator: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	default_rotation = rotation
	rotator = global_rotation
	if !is_moving:
		if !elevator_doors.is_empty():
			get_tree().root.get_node(elevator_doors[current_floor]).door_open()
		door_open()
	on_start()

func on_start():
	pass

 # Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if waypoints != null:
		if is_moving && waypoints.size() > 0:
			global_position = global_position.move_toward(waypoints[counter][0], speed * delta)
			if waypoints[counter][1] == default_rotation:
				global_rotation = global_rotation.move_toward(waypoints[counter][1], speed * delta)
			else:
				global_rotation = global_rotation.move_toward(waypoints[counter][1] + default_rotation, speed * delta)
			for i in range(objects_to_teleport.size()):
				var node: Node3D = get_node(objects_to_teleport[i])
				node.global_rotation = node.global_rotation + (global_rotation - rotator)
				rotator = global_rotation
			# remember, floating numbers needs IsEqualApprox, Yni!
			if global_position.is_equal_approx(waypoints[counter][0]):
				if (counter < waypoints.size() - 1):
					counter += 1
				else:
					counter = 0
					waypoints.clear()
					if pass_floor:
						if last_move == LastMove.DOWN:
							if (current_floor < target_floor - 1):
								elevator_move(true, false)
							else:
								elevator_move(false, false)
						elif last_move == LastMove.UP:
							if (current_floor > target_floor + 1):
								elevator_move(true, false)
							else:
								elevator_move(false, false)
					else:
						is_moving = false
						changed_launch_state.emit(false)
						get_node("Move").stop()
						call("open_dest_doors")
	on_update(delta)

func on_update(delta):
	pass

# Open the door
func door_open():
	var rng = RandomNumberGenerator.new()
	$AnimationPlayer.play("door_open")
	if get_node_or_null(navigation_link) != null:
		get_node(navigation_link).enabled = true
	set_physics_process(false)
	if !open_door_sounds.is_empty():
		$DoorSound.stream = load(open_door_sounds[rng.randi_range(0, open_door_sounds.size() - 1)])
		$DoorSound.play()
# Closes the door
func door_close():
	var rng = RandomNumberGenerator.new()
	$AnimationPlayer.play("door_open", -1, -1, true)
	if get_node_or_null(navigation_link) != null:
		get_node(navigation_link).enabled = false
	$AnimationPlayer.connect("animation_finished", _on_animation_finished)
	if !close_door_sounds.is_empty():
		$DoorSound.stream = load(close_door_sounds[rng.randi_range(0, close_door_sounds.size() - 1)])
		$DoorSound.play()

## Moves elevator (network method)
func call_elevator(floor):
	if is_moving || floor == current_floor || locked:
		return
	changed_launch_state.emit(true)
	target_floor = floor
	if floors.size() == 1 || abs(target_floor - current_floor) == 1:
		elevator_move(false, true)
	else:
		elevator_move(true, true)
func elevator_move(p_pass_floor: bool, first : bool):
	pass_floor = p_pass_floor
	if first:
		if !elevator_doors.is_empty():
			get_tree().root.get_node(elevator_doors[current_floor]).door_close()
		door_close()
	var floor: int
	if (target_floor < current_floor):
		last_move = LastMove.UP
		floor = current_floor - 1
		#check if upper point of current floor exist
		if (floors[current_floor].up_helper_point != ""):
			waypoints.append([get_node(floors[current_floor].up_helper_point).global_position, get_node(floors[current_floor].up_helper_point).global_rotation])
		#check if lower point of next floor exist
		if (floors[floor].down_helper_point != ""):
			waypoints.append([get_node(floors[floor].down_helper_point).global_position, get_node(floors[floor].down_helper_point).global_rotation])
		waypoints.append([get_node(floors[floor].destination_point).global_position, get_node(floors[floor].destination_point).global_rotation])
		current_floor = floor
	elif (target_floor > current_floor):
		last_move = LastMove.DOWN
		floor = current_floor + 1
		#check if lower point of current floor exist
		if (floors[current_floor].down_helper_point != ""):
			waypoints.append([get_node(floors[current_floor].down_helper_point).global_position, get_node(floors[current_floor].down_helper_point).global_rotation])
		#check if upper point of next floor exist
		if (floors[floor].up_helper_point != ""):
			waypoints.append([get_node(floors[floor].up_helper_point).global_position, get_node(floors[floor].up_helper_point).global_rotation])
		waypoints.append([get_node(floors[floor].destination_point).global_position, get_node(floors[floor].destination_point).global_rotation])
		current_floor = floor
	is_moving = true
	if !$Move.playing:
		$Move.play()
# Opens destination doors.
func open_dest_doors():
	if !elevator_doors.is_empty():
		get_tree().root.get_node(elevator_doors[current_floor]).door_open()
	door_open()

func interact_up(player):
	var dir : int = current_floor - 1
	if dir >= 0 && !is_moving:
		call("call_elevator", dir) #move the elevator up.

func interact_down(player):
	var dir : int = current_floor + 1
	if dir < floors.size() && !is_moving:
		call("call_elevator", dir) #move the elevator down.

func on_player_area_body_entered(body):
	if body is PlayerScript || body is MovableNpc: #|| body is Pickable:
		call("add_object", body.get_path())

func on_player_area_body_exited(body):
	if body is PlayerScript || body is MovableNpc: # || body is Pickable:
		call("remove_object", body.get_path())

func add_object(body):
	if get_node(body) is MovableNpc:
		changed_launch_state.connect(get_node(body).on_moving_platform)
	objects_to_teleport.append(body)

func remove_object(body):
	if get_node(body) is MovableNpc:
		changed_launch_state.disconnect(get_node(body).on_moving_platform)
	objects_to_teleport.erase(body)

func _on_animation_finished(anim_name):
	$AnimationPlayer.disconnect("animation_finished", _on_animation_finished)
	set_physics_process(true)
