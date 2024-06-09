extends Node

@onready var players = [$"PlayerOne",$PlayerTwo]
@onready var player_scores = [$"PlayerOneScore",$PlayerTwoScore]

const DEAD_ZONE:float = .15
const MAX_ANALOG:float = .85
var player_speed = 300
var rotate_speed = 3
var player_check_points=[[0,0],[0,0]]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_movement(players[0],0,delta)
	player_movement(players[1],1,delta)


func player_movement(player: Node,player_number:int,delta):
	var x:float = 0
	var y:float = 0
	var controller = floori((player_number)/2.)
	var stick = (player_number) % 2
	if stick == 0:
		x = Input.get_joy_axis(controller,JOY_AXIS_LEFT_X)
		y = Input.get_joy_axis(controller,JOY_AXIS_LEFT_Y)
	if stick == 1:
		x = Input.get_joy_axis(controller,JOY_AXIS_RIGHT_X)
		y = Input.get_joy_axis(controller,JOY_AXIS_RIGHT_Y)
	if player_number == 1:
		x*=-1
		y*=-1
	if abs(x) > DEAD_ZONE:
		if abs(x) > MAX_ANALOG:
			x = MAX_ANALOG * (abs(x)/x) #1 or -1
		if  x <0:
			x *= .25
		player.velocity = Vector2(x,0) * (player_speed)
		player.velocity = player.velocity.rotated(player.rotation)
	else:
		player.velocity = Vector2(0,0)
	if abs(y) > DEAD_ZONE:
		if abs(y) > MAX_ANALOG:
			y = MAX_ANALOG * (abs(y)/y) #1 or -1
		player.rotation += y*delta *rotate_speed


	player.move_and_slide()
	
func distance(pos1, pos2) -> float:
	return sqrt((pos1.x-pos2.x)**2 + (pos1.y-pos2.y)**2)
	
func reset():
	for i in 2:
		player_scores[i].text = "0"
	players[0].position = Vector2(100,400)
	players[1].position = Vector2(160,400)
	players[0].rotation = deg_to_rad(90)
	players[1].rotation = deg_to_rad(90)

func _on_finish_line_body_entered(body):
	if body.is_in_group("player_one"):
		if player_check_points[0] == [1,1]:
			player_scores[0].text = str(int(player_scores[0].text)+1)
			player_check_points[0] = [0,0]
	elif body.is_in_group("player_two"):
		if player_check_points[1] == [1,1]:
			player_scores[1].text = str(int(player_scores[1].text)+1)
			player_check_points[1] = [0,0]


func _on_checkpoint_1_body_entered(body):
	if body.is_in_group("player_one"):
		player_check_points[0][0] = 1
	elif body.is_in_group("player_two"):
		player_check_points[1][0] = 1


func _on_checkpoint_3_body_entered(body):
	if body.is_in_group("player_one"):
		player_check_points[0][1] = 1
	elif body.is_in_group("player_two"):
		player_check_points[1][1] = 1
