extends Control

@export var is_game: bool = false
@export var path: String = ""
@export var loading: bool = false
@export var save_file: GameData
@export var previous_path: String

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if loading:
		var progress: Array
		var status = ResourceLoader.load_threaded_get_status(path, progress)
		if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			$ProgressBar.value = progress[0] * 100
		elif status == ResourceLoader.THREAD_LOAD_LOADED:
			$ProgressBar.value = 100
			loading = false
			var game: Node = ResourceLoader.load_threaded_get(path).instantiate()
			if is_game:
				if save_file != null:
					game.game_data = save_file
				else:
					game.game_data = load("res://Scripts/GameData/gamedata.tres")
			get_tree().root.add_child(game)
			get_tree().root.get_node(previous_path).queue_free()

func load_game():
	ResourceLoader.load_threaded_request(path)
	loading = true
