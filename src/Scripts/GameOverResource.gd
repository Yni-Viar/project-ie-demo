extends Resource
class_name GameOverResource
## Made by Yni, licensed under MIT License.

## GameOver background image.
@export var screen: Texture2D
## GameOver label
@export var text: String
## Reason for GameOver.
@export var reason: String

func _init(p_screen = null, p_text = "", p_reason = ""):
	screen = p_screen
	text = p_text
	reason = p_reason
