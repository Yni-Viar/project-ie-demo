extends InteractableStatic

@export var door_path: NodePath

func interact(player: Node3D):
	get_node(door_path).call("door_control", player.get_path(), -1, false, true)
