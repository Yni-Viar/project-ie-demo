extends Window
class_name IngameWindow
## Made by Yni, licensed under CC0.

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_close_requested() -> void:
	queue_free()
