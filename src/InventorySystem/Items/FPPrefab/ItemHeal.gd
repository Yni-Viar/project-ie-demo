extends ItemUse

@export var amount: float = 20
@export var type_of_health: int = 0

func on_update(delta):
	if Input.is_action_pressed("interact"):
		on_use(get_tree().get_node("Game/Player"))

func on_use(player):
	player.health_manage(amount, type_of_health, "Healed!")
	super.on_use(player)
