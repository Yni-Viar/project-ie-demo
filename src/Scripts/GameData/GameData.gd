extends Resource
## Game DB.
## Made by Yni, licensed under MIT license.
class_name GameData

## Available inventory items
@export var items: Array[Item]
## Inventory items (use Vector2 as the key and key of item variable as thje value)
## E.g. Vector2(1, 1) - 0 means that in position 1, 1 is 0 - Sugar milk
@export var inventory_items: Dictionary
## Player position
@export var position: Vector3
## Storyline. Your choices lead to different ending...
@export_flags("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15") var story_flag: int = 0
## Health
@export var health: float
## Collectable items
@export var applied_keys: Array[int]
## Collected unique items
@export var collected_item_path: Array[String]


# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_items: Array[Item] = []):
	items = p_items
