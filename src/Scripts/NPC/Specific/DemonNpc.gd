extends StaticNpc

var rng: RandomNumberGenerator
var update_timer: float = 1.0
var pos_to_move: Vector3

func _ready() -> void:
	rng = get_tree().root.get_node("Game").rng

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position.move_toward(pos_to_move, 1.5 * delta)
	new_point(delta)

func new_point(delta: float):
	if update_timer > 0:
		update_timer -= delta
	else:
		pos_to_move = Vector3(global_position) + Vector3(rng.randf_range(1.0, 2.0), rng.randf_range(1.0, 2.0), rng.randf_range(1.0, 2.0))
		update_timer = 1.0
