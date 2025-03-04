extends HBoxContainer
## Touch screen controls
## Created by Yni, licensed under MIT License


func _on_tap_button_down() -> void:
	Input.action_press("interact")


func _on_tap_button_up() -> void:
	Input.action_release("interact")


#func _on_tap_with_item_button_down() -> void:
	#Input.action_press("interact_alt")
#
#
#func _on_tap_with_item_button_up() -> void:
	#Input.action_release("interact_alt")


func _on_inventory_button_down() -> void:
	Input.action_press("human_inventory")


func _on_inventory_button_up() -> void:
	Input.action_release("human_inventory")
