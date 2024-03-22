extends Node2D

const SPEED:int = 300
const DEAD_ZONE:float = .15
const MAX_ANALOG:float = .85
@onready var players_node = $Players

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		for i in players_node.get_child_count():
			player_movement(i)


func player_movement(player_number: int = 0):
	var x:float = 0
	var y:float = 0
	if player_number == 0:
		x = Input.get_joy_axis(0,JOY_AXIS_LEFT_X)
		y = Input.get_joy_axis(0,JOY_AXIS_LEFT_Y)
	if player_number == 1:
		x = Input.get_joy_axis(0,JOY_AXIS_RIGHT_X)
		y = Input.get_joy_axis(0,JOY_AXIS_RIGHT_Y)
	var d:float = sqrt(x**2 + y**2)
	var v:Vector2 = Vector2(0,0)
	if d < DEAD_ZONE:
		v = Vector2(0,0)
	elif d > MAX_ANALOG:
		v = Vector2(x,y)/d
	else:
		v = Vector2(x,y)
	players_node.get_child(player_number).velocity = v * SPEED
	players_node.get_child(player_number).move_and_slide()
