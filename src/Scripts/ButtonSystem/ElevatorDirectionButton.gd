extends InteractableStatic
## Made by Yni, licensed under CC0.
## Unused in this demo. This is a legacy code, dating back to TGPY and SCP: Site Online

enum Direction {down, up}
@export var elevator_direction: Direction = Direction.up

func interact(player: Node3D):
	match elevator_direction:
		Direction.down:
			if get_parent().has_method("interact_down"):
				get_parent().call("interact_down", player)
		Direction.up:
			if get_parent().has_method("interact_up"):
				get_parent().call("interact_up", player)
