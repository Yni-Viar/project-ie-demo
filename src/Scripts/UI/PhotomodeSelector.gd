extends HBoxContainer
## Made by Yni, licensed under CC0.

var player: PlayerScript
var button_busy = false

func _on_visibility_changed() -> void:
	if visible:
		player = get_tree().root.get_node("Game/Player")


func _on_normal_button_down() -> void:
	if !button_busy:
		player.apply_shader("")
		button_busy = true


func _on_toon_button_down() -> void:
	if !button_busy:
		player.apply_shader("ToonShader")
		button_busy = true


func _on_edge_detect_button_down() -> void:
	if !button_busy:
		player.apply_shader("EdgeDetectShader")
		button_busy = true



func _on_normal_button_up() -> void:
	button_busy = false


func _on_toon_button_up() -> void:
	button_busy = false


func _on_edge_detect_button_up() -> void:
	button_busy = false
