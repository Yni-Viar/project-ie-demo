extends InteractableNode

@export var path: String
@export var floor: int

func interact(player: Node3D):
	if get_tree().root.get_node_or_null(path) != null:
		var elevator = get_tree().root.get_node(path)
		elevator.call("call_elevator", floor)
	super.interact(player)
