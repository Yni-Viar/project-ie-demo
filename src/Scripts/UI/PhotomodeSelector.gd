extends HBoxContainer

var player: PlayerScript

func _on_normal_pressed() -> void:
	player.apply_shader("")


func _on_toon_pressed() -> void:
	player.apply_shader("ToonShader")


func _on_edge_detect_pressed() -> void:
	player.apply_shader("EdgeDetectShader")


func _on_visibility_changed() -> void:
	if visible:
		player = get_tree().root.get_node("Game/Player")
