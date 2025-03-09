extends TextureRect
## Made by Yni, licensed under CC0
## Made primarily for touch controls

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is InventorySlot:
		get_parent().get_node("Inventory").item_remove(data, true)
