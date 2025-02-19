extends InteractableRigidBody
class_name ActionPickable

var player_prefab: PlayerScript
@export var is_collectable: bool = false
@export var id: int
@export var public_name: String
@export var icon: Texture2D
@export var mouse_sensitivity = 0.05
var collectable_first_time: bool = true
func _input(event):
	if player_prefab != null:
		if event is InputEventMouseMotion && Input.is_action_pressed("item_inspect") && player_prefab.using_item == str(get_path()):
			rotate_y(-event.relative.x * mouse_sensitivity)
			rotate_x(-event.relative.y * mouse_sensitivity)

func _process(delta):
	if player_prefab != null:
		if player_prefab.using_item == str(get_path()):
			global_position = get_tree().root.get_node("Game/Player/PlayerHead/PlayerRecoil/PlayerHand").global_position

func interact(player: Node3D):
	if player.using_item != str(get_path()):
		call("pick", player.get_path())
	else:
		call("use", self)

func interact_alt(player: Node3D):
	if player.using_item == str(get_path()):
		if is_collectable:
			queue_free()
		else:
			call("throw", player.get_path())

func use(player: Node3D):
	pass

## Picks up an object
func pick(player: String):
	freeze = true
	player_prefab = get_node(player)
	player_prefab.using_item = get_path()
	
	if is_collectable && collectable_first_time:
		pass

## Throws an object
func throw(player: String):
	freeze = false
	player_prefab.using_item = ""
	player_prefab = null
	
