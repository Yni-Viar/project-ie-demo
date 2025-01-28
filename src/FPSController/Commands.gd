extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	GDsh.add_command("givehp", set_health, "Adds or depletes health values")
	GDsh.add_command("give", give, "Gives an item to you.")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_health(args: Array):
	if args.size() == 1:
		get_parent().call("health_manage", args[0], 0, "Forced health change")
		return "Given " + args[0] + " to your health"
	elif args.size() == 2:
		get_parent().call("health_manage", args[0], args[1], "Forced health change")
		return "Given " + args[0] + " to your health " + args[1]
	else:
		return "Error. Needed 1 argument, if you want to add/deplete to generic
		health, or 2 args, where first arg is amount of health, and the second one is the type of health"

func give(args: Array):
	if args.size() == 1:
		if int(args[0]) < get_tree().root.get_node("Main/Game/").game_data.map_objects.size() && int(args[0]) >= 0:
			#give_cmd(int(args[0]), 0)
			return "An item was given"
		else:
			return "Unknown item. Cannot spawn. E.g. to spawn an item, you need to write \"give <number>\""
	else:
		return "Unknown item. Cannot spawn. Did you input the number of item?"

#func give_cmd(key: int, type: int):
	#var nodepath: String
	#match type:
		#0:
			#nodepath = "MapObjects"
		#1:
			#nodepath = "Npcs"
	#var node: Node3D = 
	#get_parent().get_parent().get_node(nodepath)
