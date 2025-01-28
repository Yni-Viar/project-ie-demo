extends Area3D
class_name BackgroundMusicChanger

@export var in_room_music: String
@export var outside_music_id: int

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if Settings.main_optimizator <= 1:
		set_process(false)
		set_physics_process(false)

func _on_body_entered(body):
	if body is PlayerScript:
		body.get_parent().set_background_music(in_room_music)

func _on_body_exited(body):
	if body is PlayerScript:
		body.get_parent().set_background_music(body.get_parent().music_to_play[outside_music_id])
