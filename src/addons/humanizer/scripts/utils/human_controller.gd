extends CharacterBody3D

enum State {
	IDLE,
	WALKING,
	RUNNING
}

@export var camera: Node3D
@export_range(0.1, 5) var move_speed: float = 2
@export_range(0, 100) var vertical_impulse: float = 60

var skeleton: Skeleton3D = $GeneralSkeleton
const GRAVITY: float  = 9.8

@export var state: State = State.IDLE

# Advance expressions
var moving: bool = false
@onready var anim = $AnimationTree as AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready():	
	if get_node_or_null("GeneralSkeleton") == null:
		skeleton = $Armature/GeneralSkeleton
	else:
		skeleton = $GeneralSkeleton
	
	# Seems like animation tree has to be inactivated for this to work
	anim.active = false
	anim.advance_expression_base_node = get_path()
	anim.active = true
	
	skeleton.physical_bones_stop_simulation()
	skeleton.animate_physical_bones = false

func _physics_process(delta):
	if camera == null:
		return
	
	var cam_right: Vector3 = camera.basis.x
	var cam_forward: Vector3 = -camera.basis.z
	cam_right.y = 0
	cam_forward.y = 0
	cam_right = cam_right.normalized()
	cam_forward = cam_forward.normalized()
	
	var move_input: Vector2 = Input.get_vector(
		&'ui_left', &'ui_right', &'ui_down', &'ui_up')
	moving = move_input.length() > 0.1  # Give a little deadzone
	
	animation_state_machine(delta)
	
	var movement: Vector3 = move_input.x * cam_right + move_input.y * cam_forward
	if moving:
		# IDK why negative signs but it works
		transform.basis = Basis.looking_at(-movement)
		state = State.WALKING
	else:
		state = State.IDLE
	
	movement = movement * move_speed
	velocity.x = movement.x
	velocity.z = movement.z
	velocity.y -= GRAVITY * delta

	if Input.is_action_just_pressed(&'ui_accept'):
		if skeleton != null:
			if skeleton.get_child_count() > 0:
				if (skeleton.get_child(0) as PhysicalBone3D).is_simulating_physics():
					skeleton.physical_bones_stop_simulation()
				else:
					skeleton.physical_bones_start_simulation()
					(skeleton.get_child(0) as PhysicalBone3D).linear_velocity = velocity
					(skeleton.get_child(0) as PhysicalBone3D).apply_impulse(Vector3.UP * vertical_impulse)
	move_and_slide()

func animation_state_machine(delta: float):
	match state:
		State.IDLE:
			if anim["parameters/state_machine/blend_amount"] + 0.001 >= -1:
				anim["parameters/state_machine/blend_amount"] = move_toward(anim["parameters/state_machine/blend_amount"], -1, delta * 2)
		State.WALKING:
			if anim["parameters/state_machine/blend_amount"] + 0.001 >= 0:
				anim["parameters/state_machine/blend_amount"] = move_toward(anim["parameters/state_machine/blend_amount"], 0, delta * 2)
		State.RUNNING:
			if anim["parameters/state_machine/blend_amount"] - 0.001 <= 1:
				anim["parameters/state_machine/blend_amount"] = move_toward(anim["parameters/state_machine/blend_amount"], 1, delta * 2)
