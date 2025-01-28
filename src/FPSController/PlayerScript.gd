extends CharacterBody3D
class_name PlayerScript

#Created by dzejpi. License - The Unlicense. 
#Some parts used from elmarcoh (this script is also public domain).
# Ported from C# in 04.2024
@onready var player_head = $PlayerHead
@onready var ray = $PlayerHead/PlayerRecoil/RayCast3D
@onready var watch_ray = $PlayerHead/PlayerRecoil/VisionRadius
@onready var walk_sounds = $WalkSounds
@onready var interact_sound = $InteractSound

@export var player_name: String
@export var spawn_point: String
@export var health: Array[float] = [100]
@export var current_health: Array[float] = [100]
@export var speed: float = 4.5
@export var jump: float = 4.5
@export var sprint_enabled: bool = false
@export var move_sounds_enabled: bool = false
@export var footstep_sounds: Array[String]
@export var sprint_sounds: Array[String]
@export var ragdoll_source: String
#@export var enable_inventory: bool = false
# Unique Number. Set -1 for common entities (such as humans),
# -2 for spectators, and 0 and above for entities with special abilities.
@export var can_move: bool = true
@export var using_item: String = ""
#@export var custom_music: bool = false
@export var custom_camera: bool = false
@export var keycards: Array[int]
var gravity: float = 9.8

var acceleration: float = 8
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
# var mouse_sensitivity = 0.05

var direction = Vector3()
var vel = Vector3()
var movement = Vector3()
var gravity_vector = Vector3()

var is_sprinting: bool = false
var is_walking: bool = false

# Name of the observed object for debugging purposes
var observed_object = ""

func _ready():
	
	$PlayerHead/PlayerRecoil/PlayerCamera.current = true
	floor_max_angle = 1.308996
	ray.add_exception(self)
	watch_ray.add_exception(self)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	on_start()

## Start for all players
func on_start():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * Settings.setting_res.mouse_sensitivity * 0.05)
		player_head.rotate_x(clamp(-event.relative.y * Settings.setting_res.mouse_sensitivity * 0.05, -90, 90))
		
		var camera_rot = player_head.rotation_degrees
		camera_rot.x = clamp(player_head.rotation_degrees.x, -85, 85)
		player_head.rotation_degrees = camera_rot

	direction = Vector3()
	direction.z = -Input.get_action_strength("move_forward") + Input.get_action_strength("move_backward")
	direction.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	direction = direction.normalized().rotated(Vector3.UP, rotation.y)
	
	# Handling the options menu
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#			is_options_menu_displayed = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#			is_options_menu_displayed = false
	if Input.is_action_just_pressed("mode_kinematic"):
		get_parent().get_node("PlayerUI").visible = !get_parent().get_node("PlayerUI").visible



func _physics_process(delta):
	if is_on_floor():
		gravity_vector = Vector3.ZERO
	else:
		gravity_vector += Vector3.DOWN * gravity * delta

	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		gravity_vector = Vector3.UP * jump
	if can_move:
		if Input.is_action_pressed("move_sprint"):
			vel = vel.lerp(direction * speed * 2, acceleration * delta)
		else:
			vel = vel.lerp(direction * speed, acceleration * delta)
		movement.z = vel.z + gravity_vector.z
		movement.x = vel.x + gravity_vector.x
		movement.y = gravity_vector.y
		set_velocity(movement)
	else:
		set_velocity(Vector3.ZERO)
	if Input.is_action_just_pressed("interact_alt") && !using_item.is_empty():
		var check = get_node_or_null(using_item)
		if check != null:
			if check is ActionPickable:
				check.call("interact_alt", self)
	if ray.is_colliding():
		if Input.is_action_just_pressed("interact"):
			var collided_with = ray.get_collider()
			if collided_with is InteractableNode:
				collided_with.call("interact", self)
			elif collided_with is InteractableRigidBody:
				collided_with.call("interact", self)
			elif collided_with is InteractableNpc:
				collided_with.call("interact")
			elif collided_with is PathWalkerHelper:
				collided_with.call("interact")
		elif Input.is_action_just_pressed("interact_alt"):
			var collided_with = ray.get_collider()
			if collided_with is InteractableNode:
				collided_with.call("interact_alt", self)
			elif collided_with is InteractableRigidBody:
				collided_with.call("interact_alt", self)
	get_parent().get_node("PlayerUI/HealthBar").value = ceil(current_health[0])
	set_up_direction(Vector3.UP)
	move_and_slide()

func hold_item(item_id: int):
	if item_id >= 0 && item_id < get_tree().root.get_node("Main/Game").game_data.items.size():
		var check = get_node("PlayerModel").get_child(0)
		if check == null:
			return
		#var path = str(check.get_path()) + "/" + check.armature_name + "/Skeleton3D/ItemAttachment/ItemInHand"
		#if check.get_node_or_null(str(check.get_path()) + "/" + check.armature_name + "/Skeleton3D/ItemAttachment/ItemInHand") != null && !is_multiplayer_authority():
			#$PlayerHead/PlayerRecoil/PlayerHand.hide()
			#var path_to_item_hold: Marker3D = check.get_node(str(check.get_path()) + "/" + check.armature_name + "/Skeleton3D/ItemAttachment/ItemInHand")
			#for node in path_to_item_hold.get_children():
				#node.queue_free()
			#var pickable: ItemPickable = load(get_tree().root.get_node("Main/Game").game_data.items[item_id].pickable).instantiate()
			#pickable.freeze = true
			#path_to_item_hold.add_child(pickable)
		#else:
			#$PlayerHead/PlayerRecoil/PlayerHand.show()
		if $PlayerHead/PlayerRecoil/PlayerHand.visible:
			for node in $PlayerHead/PlayerRecoil/PlayerHand.get_children():
				node.queue_free()
			var item_use: ItemUse = load(get_tree().root.get_node("Main/Game").game_data.items[item_id].first_person_prefab_path).instantiate()
			item_use.one_time_use = get_tree().root.get_node("Main/Game").game_data.items[item_id].one_time_use
			item_use.index = item_id
			$PlayerHead/PlayerRecoil/PlayerHand.add_child(item_use)
	else:
		var check = get_node("PlayerModel").get_child(0)
		if check == null:
			return
		if check.get_node_or_null(str(check.get_path()) + "/" + check.armature_name + "/Skeleton3D/ItemAttachment/ItemInHand") != null:
			var path_to_item_hold: Marker3D = check.get_node(str(check.get_path()) + "/" + check.armature_name + "/Skeleton3D/ItemAttachment/ItemInHand")
			for node in path_to_item_hold.get_children():
				node.queue_free()
		for node in $PlayerHead/PlayerRecoil/PlayerHand.get_children():
			node.queue_free()

## Animation-based footstep system.
func footstep_animate():
	if move_sounds_enabled:
		if is_walking:
			rpc("play_footstep_sound", false)
		if is_sprinting:
			rpc("play_footstep_sound", true)

## Make footstep sounds audible to all.
@rpc("any_peer", "call_local")
func play_footstep_sound(sprinting: bool):
	if sprinting:
		walk_sounds.stream = load(sprint_sounds[rng.randi_range(0, sprint_sounds.size() - 1)])
		walk_sounds.play()
	else:
		walk_sounds.stream = load(footstep_sounds[rng.randi_range(0, footstep_sounds.size() - 1)])
		walk_sounds.play()

## Health manager.
@rpc("any_peer", "call_local")
func health_manage(amount: float, type_of_health: int, deplete_reason: String):
	if type_of_health >= current_health.size():
		return
	if current_health[type_of_health] + amount <= health[type_of_health]:
		current_health[type_of_health] += amount
	else:
		current_health[type_of_health] == health[type_of_health]
	if current_health[type_of_health] <= 0:
		get_tree().root.get_node("Main/Game").rpc_id(multiplayer.get_unique_id(), "set_player_class", str(multiplayer.get_unique_id()), 0, deplete_reason, false)
		pass

##s Applies shader to the player
func apply_shader(res: String):
	for node in get_node("PlayerHead/PlayerRecoil/PlayerCamera").get_children():
		if node is MeshInstance3D:
			node.visible = false
	if get_node_or_null("PlayerHead/PlayerRecoil/PlayerCamera" + res) != null && !res.is_empty():
		get_node("PlayerHead/PlayerRecoil/PlayerCamera" + res).visible = true

## Sets players view
func camera_manager(default_camera: bool):
	if default_camera:
		get_node("PlayerHead/PlayerRecoil/PlayerCamera").current = true
		if !OS.is_debug_build():
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		custom_camera = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		custom_camera = true
## Updates class UI
#func update_class_ui(color: int):
	#var class_color: Color = Color(color)
	#if get_parent().get_node("PlayerUI/HealthBar").has_theme_stylebox_override("fill"):
		#get_parent().get_node("PlayerUI/HealthBar").remove_theme_stylebox_override("fill")
		#var class_represent: StyleBoxFlat = StyleBoxFlat.new()
		#class_represent.set_bg_color(class_color)
		#get_parent().get_node("PlayerUI/HealthBar").add_theme_stylebox_override("fill", class_represent)
		#get_parent().get_node("PlayerUI/HealthBar").max_value = health[0]
		#get_parent().get_node("PlayerUI/HealthBar").value = current_health[0]
		#if (get_parent().get_node("PlayerUI/ClassInfo").has_theme_color_override("font_color")):
			#get_parent().get_node("PlayerUI/ClassInfo").remove_theme_color_override("font_color")
		#get_parent().get_node("PlayerUI/ClassInfo").add_theme_color_override("font_color", class_color)
		#get_parent().get_node("PlayerUI/ClassInfo").text = player_class_name
		#get_parent().get_node("PlayerUI/ClassDescription").text = player_class_description
		#get_parent().get_node("PlayerUI/AnimationPlayer").play("forceclass")
