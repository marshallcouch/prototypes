extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_up():
	var new_gravity:Vector2 
	if abs($"Game Area".position.y) < 0.1:
		$"Game Area".rotate(deg_to_rad(-90))
		$"Game Area".position.y = 1560
		new_gravity = Vector2(1,0)
		$"Game Area/RigidBody2D".linear_velocity = $"Game Area/RigidBody2D".linear_velocity.rotated(deg_to_rad(-90))
	else:
		$"Game Area".rotation = 0.0
		$"Game Area".position.y = 0.0
		new_gravity = Vector2(0,1)
		$"Game Area/RigidBody2D".linear_velocity = $"Game Area/RigidBody2D".linear_velocity.rotated(deg_to_rad(90))
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, new_gravity)
