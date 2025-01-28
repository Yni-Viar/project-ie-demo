extends Resource
class_name GameOverResource

@export var screen: Texture2D
@export var text: String
@export var reason: String

func _init(p_screen = null, p_text = "", p_reason = ""):
	screen = p_screen
	text = p_text
	reason = p_reason
