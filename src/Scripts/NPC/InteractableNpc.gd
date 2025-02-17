extends CharacterBody3D
class_name InteractableNpc

enum State {
	IDLE,
	WALKING,
	RUNNING
}
@export var character_speed: float = 4.0
#@export var armature_name: String = "Armature"
@export var can_talk: bool = false
@export var dialogues: Array[Array]
@export var state: State = State.IDLE
@export var apply_height_bugfix: bool = false
@export var height_bugfix_amount: float = -0.04
@export var platform_moving: bool = false

var current_dialogue: int = 0
var follow_update_timer: float = 1.0
var follow_target: String = ""
var prev_offset: PackedVector3Array = [Vector3.ONE, Vector3.ONE]
var height_bugfix_applied: bool = false

# Begin Godot Demo code (MIT License)
@onready var anim = $AnimationTree as AnimationTree
@onready var _nav_agent := $NavigationAgent3D as NavigationAgent3D

func _ready() -> void:
	anim.active = false
	anim.advance_expression_base_node = get_path()
	anim.active = true
	#state = State.IDLE

func _physics_process(delta: float) -> void:
	animation_state_machine(delta)
	if platform_moving:
		state = State.IDLE
		if !is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return
	if !follow_target.is_empty():
		if get_node_or_null(follow_target) != null:
			target_follow()
	if _nav_agent.is_navigation_finished():
		if state != State.IDLE:
			# Strange bug fix (where NPC was always had standing animation (even when moving))
			if global_position.distance_to(_nav_agent.get_final_position()) <= 1:
				state = State.IDLE
		return
	
	var next_position := _nav_agent.get_next_path_position()
	var offset := next_position - global_position
	if !offset.is_equal_approx(prev_offset[1]) && !offset.is_equal_approx(prev_offset[0]):
		global_position = global_position.move_toward(next_position, delta * character_speed)
		look_at(global_position + Vector3(offset.x, 0, offset.z), Vector3.UP)
	else:
		state = State.IDLE
	
	prev_offset[1] = prev_offset[0]
	prev_offset[0] = offset

func set_target_position(target_position: Vector3) -> void:
	_nav_agent.set_target_position(target_position)
	if character_speed > 10:
		state = State.RUNNING
	else:
		state = State.WALKING
	if apply_height_bugfix && !height_bugfix_applied:
		$Armature.position.y = height_bugfix_amount

# End Godot Demo code (MIT License)

func animation_state_machine(delta: float):
	match state:
		State.IDLE:
			if anim["parameters/state_machine/blend_amount"] - 0.001 >= -1:
				anim["parameters/state_machine/blend_amount"] = move_toward(anim["parameters/state_machine/blend_amount"], -1, delta * 2.5)
		State.WALKING:
			if anim["parameters/state_machine/blend_amount"] + 0.001 <= 0:
				anim["parameters/state_machine/blend_amount"] = move_toward(anim["parameters/state_machine/blend_amount"], 0, delta * 2.5)
		State.RUNNING:
			if anim["parameters/state_machine/blend_amount"] + 0.001 <= 1:
				anim["parameters/state_machine/blend_amount"] = move_toward(anim["parameters/state_machine/blend_amount"], 1, delta * 2.5)

## Start dialogue with NPC
func interact(must_talk: bool = false):
	if can_talk || must_talk:
		get_tree().root.get_node("Game/PlayerUI").speak(dialogues[current_dialogue][0], dialogues[current_dialogue][1], get_path())

func target_follow():
	if follow_update_timer > 0:
		follow_update_timer -= get_physics_process_delta_time()
	else:
		set_target_position(get_node(follow_target).global_position - get_node(follow_target).global_transform.basis.z * 1.5)
		follow_update_timer = 1.0

func on_moving_platform(start: bool):
	platform_moving = start
