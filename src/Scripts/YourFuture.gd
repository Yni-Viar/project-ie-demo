extends Panel
# Made by Yni, licensed under CC0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = tr("YOURFUTURE") % str(get_tree().root.get_node("Game").rng.seed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
