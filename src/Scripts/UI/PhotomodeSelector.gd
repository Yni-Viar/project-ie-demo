extends HBoxContainer

var player_camera: Node3D

func _on_normal_pressed() -> void:
	clear_effects()


func _on_toon_pressed() -> void:
	clear_effects()
	player_camera.get_node("ToonShader").show()


func _on_edge_detect_pressed() -> void:
	clear_effects()
	player_camera.get_node("EdgeDetectShader").show()


func clear_effects():
	for node in player_camera.get_children():
		node.hide()


func _on_visibility_changed() -> void:
	if visible:
		player_camera = get_tree().root.get_node("Game/Player/PlayerHead/PlayerRecoil/PlayerCamera")
