extends InteractableNode


func interact(player: Node3D):
	get_parent().get_parent().rpc("door_control", player.get_path(), -1)
