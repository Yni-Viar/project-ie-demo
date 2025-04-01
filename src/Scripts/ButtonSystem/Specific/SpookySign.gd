extends InteractableStatic

var enabled: bool = false

func interact(player: Node3D):
	super.interact(player)
	if !enabled:
		$SpookySign.mesh.surface_set_material(0, load("res://Assets/Materials/noescape_dll.tres"))
		$SpookySound.play()
		enabled = true
	else:
		$SpookySign.mesh.surface_set_material(0, load("res://Assets/Materials/noescape.tres"))
		$SpookySound.stop()
		enabled = false
