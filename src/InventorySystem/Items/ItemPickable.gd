extends InteractableRigidBody
class_name ItemPickable

@export var item: Item

func interact(player: Node3D):
	call("add_to_inventory")

func add_to_inventory():
	get_tree().root.get_node("Main/Game/" + str(multiplayer.get_unique_id()) + "/InventoryUI/Inventory").rpc_id(multiplayer.get_unique_id(), "add_item", item.id)
	call("clear_world_item")

func clear_world_item():
	queue_free()
