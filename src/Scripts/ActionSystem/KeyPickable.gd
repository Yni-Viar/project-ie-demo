extends InteractableRigidBody

@export var keycard: int

func interact(player: Node3D):
	if player is PlayerScript:
		player.keycards.append(keycard)
		super.interact(player)
		queue_free()
