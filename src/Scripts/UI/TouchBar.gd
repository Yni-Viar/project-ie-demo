extends Panel
## Touch screen controls
## Created by Yni, licensed under MIT License

var player_head: Node3D

func _ready() -> void:
	player_head = get_node("/root/Game/Player/PlayerHead")

func _gui_input(event):
	if event is InputEventScreenDrag && visible:
		player_head.rotation.y -= event.relative.x * Settings.setting_res.mouse_sensitivity * 0.05
		player_head.rotation.x -= event.relative.y * Settings.setting_res.mouse_sensitivity * 0.05
		player_head.rotation_degrees.x = clamp(player_head.rotation_degrees.x, -90, 90)
