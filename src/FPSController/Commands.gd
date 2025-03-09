extends Node
## Made by Yni, licensed under CC0
## LimboConsole commands.
## Available only in PC platforms directly, and Android platform (only with physicsl keyboard (probably))

# Called when the node enters the scene tree for the first time.
func _ready():
	LimboConsole.register_command(set_health)
	LimboConsole.register_command(spawn)
	LimboConsole.register_command(clear_spawned_items)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Set health
func set_health(amount_of_health: float, health_type: int = 0):
	get_parent().call("health_manage", amount_of_health, health_type, "Forced health change")
	LimboConsole.info("Given " + str(amount_of_health) + " to your health " + str(health_type))

# Spawn ANYTHING inside the game.
func spawn(path: String):
	if OS.get_name() == "Web":
		LimboConsole.error("It is not supported to call this command on the Web platform...")
		return
	if path.contains("user://"):
		LimboConsole.error("It is NOT supported spawning from user:// folder for security reasons.")
		return
	if !ResourceLoader.exists("res://" + path):
		LimboConsole.error("This prefab does not exist in the game. Tip: Do NOT write res:// prefix - it is already included")
		return
	var res = load("res://" + path)
	if res is PackedScene:
		var node = res.instantiate()
		node.global_position = get_parent().get_node("SpawnerMarker").global_position
		get_tree().root.get_node("Game/MapObjects").add_child(node)
	else:
		LimboConsole.error("This is not a prefab. This is a different resource.")


func clear_spawned_items():
	for node in get_tree().root.get_node("Game/MapObjects").get_children():
		node.queue_free()
	LimboConsole.info("Cleared all spawned items")

#func give_cmd(key: int, type: int):
	#var nodepath: String
	#match type:
		#0:
			#nodepath = "MapObjects"
		#1:
			#nodepath = "Npcs"
	#var node: Node3D = 
	#get_parent().get_parent().get_node(nodepath)
