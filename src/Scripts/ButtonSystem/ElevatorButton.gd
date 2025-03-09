extends InteractableStatic
## Made by Yni, licensed under CC0.
## Used for elevator calling

## Elevator path
@export var path: String
## Elevator floor
@export var floor: int

func interact(player: Node3D):
	if get_tree().root.get_node_or_null(path) != null:
		var elevator = get_tree().root.get_node(path)
		elevator.call("call_elevator", floor)
	super.interact(player)
