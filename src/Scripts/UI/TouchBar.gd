extends Panel
## Touch screen controls
## Created by Yni, licensed under MIT License

var player_head: Node3D
var dialogue_process: bool = false

func _ready() -> void:
	player_head = get_node("/root/Game/Player/PlayerHead")

func _gui_input(event):
	if event is InputEventScreenDrag && visible && !dialogue_process:
		player_head.rotation.y -= event.relative.x * Settings.setting_res.mouse_sensitivity * 0.05
		player_head.rotation.x -= event.relative.y * Settings.setting_res.mouse_sensitivity * 0.05
		player_head.rotation_degrees.x = clamp(player_head.rotation_degrees.x, -90, 90)

func _physics_process(delta: float) -> void:
	if dialogue_process:
		
