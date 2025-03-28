extends Panel
# Made by Yni, licensed under CC0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set world name (reused from SCP: Containing Procedures)
	var world_name = tr("YOURFUTURE") + " "
	for i in range(11):
		if i != 5:
			var create_char: bool = bool(get_tree().root.get_node("Game").rng.randi_range(0, 1))
			if create_char:
				world_name += char(get_tree().root.get_node("Game").rng.randi_range(0, 25) + 66)
			else:
				world_name += str(get_tree().root.get_node("Game").rng.randi_range(0, 9))
		else:
			world_name += "-"
	$Label.text = world_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
