extends InteractableRigidBody
class_name ItemPickable

@export var item: Item

func interact(player: Node3D):
	call("add_to_inventory", player.get_path())

func add_to_inventory(player_path: String):
	get_node(player_path + "/InventoryUI/Inventory/Inventory").call("add_item", item.id)
	call("clear_world_item")

func clear_world_item():
	queue_free()
