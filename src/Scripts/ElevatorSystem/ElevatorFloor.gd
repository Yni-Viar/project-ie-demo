@icon("res://Scripts/ElevatorSystem/elevator_resource.svg")
extends Resource
class_name ElevatorFloor

@export var destination_point: String
@export var up_helper_point: String
@export var down_helper_point: String

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_destination_point = "", p_up_helper_point = "", p_down_helper_point = ""):
	destination_point = p_destination_point
	up_helper_point = p_up_helper_point
	down_helper_point = p_down_helper_point
