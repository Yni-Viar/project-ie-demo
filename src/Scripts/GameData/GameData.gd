extends Resource
## Game DB.
## Made by Yni, licensed under MIT license.
class_name GameData

## Available inventory items
@export var items: Array[Item] = []
## Inventory items (use Vector2 as the key and key of item variable as thje value)
## E.g. Vector2(1, 1) - 0 means that in position 1, 1 is 0 - Sugar milk
@export var inventory_items: Dictionary = {}
## Player position
@export var position: Vector3 = Vector3.ZERO
## Health
@export var health: float = 100
## Collectable items
@export var applied_keys: Array[int] = []
## Collected unique items
@export var collected_item_path: Array[String] = []
