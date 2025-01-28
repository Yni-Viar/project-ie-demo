extends Button
class_name CollectableButton

@export var path: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)
	if Settings.setting_res.game_optimizator <= 1:
		set_process(false)
		set_physics_process(false)

func _on_pressed():
	var item: ActionPickable = load(path).instantiate()
	item.collectable_first_time = false
	get_tree().root.get_node("Game/Items").add_child(item)
	item.pick("/root/Game/Player")
