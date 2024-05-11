extends Node2D
@onready var players = $Players
@onready var player_one_score_label = $PlayerOneScore
@onready var player_two_score_label = $PlayerTwoScore
@onready var ball = $Ball
@onready var player_one = $Players/PlayerOne
@onready var player_two = $Players/PlayerTwo
var player_speed = 400
var ball_speed = 400
var ball_speed_delta = 0
const DEAD_ZONE:float = .15
const MAX_ANALOG:float = .85

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var i = 0
	for player in players.get_children():
		player_movement(player, i)
		i+=1
	
	if ball.velocity == Vector2(0,0):
		kick_off()
	check_ball_off_screen()
	ball.move_and_slide()

func check_ball_off_screen():
	if ball.position.y < 15 or ball.position.y > 785:
		ball.velocity.y = -ball.velocity.y

func kick_off():
	ball_speed_delta = 0
	if int(player_one_score_label.text) >= int(player_two_score_label.text)+ randi_range(0,1):
		ball.velocity = Vector2(ball_speed,0)
	else:
		ball.velocity = Vector2(-ball_speed,0)

func _input(_event):
	pass

func player_movement(player: Node, player_number: int):
	_coffee_table_movement(player, player_number)

func _coffee_table_movement(player: Node,player_number:int):
	var x:float = 0
	var y:float = 0
	var controller = floori((player_number)/2.)
	var stick = (player_number) % 2
	if stick == 0:
		#x = Input.get_joy_axis(controller,JOY_AXIS_LEFT_X)
		y = Input.get_joy_axis(controller,JOY_AXIS_LEFT_Y)
		
	if stick == 1:
		#x = Input.get_joy_axis(controller,JOY_AXIS_RIGHT_X)
		y = Input.get_joy_axis(controller,JOY_AXIS_RIGHT_Y)
	player.velocity = _x_y_movement(x,y) * player_speed
	if (player.position.y >= 720 and player.velocity.y > 0 ) or (player.position.y <= 80  and player.velocity.y < 0):
		return
	player.move_and_slide()
	
func _x_y_movement(x:float, y:float) -> Vector2:
	var d:float = sqrt(x**2 + y**2)
	var v:Vector2 = Vector2(0,0)
	if d < DEAD_ZONE:
		v = Vector2(0,0)
	elif d > MAX_ANALOG:
		v = Vector2(x,y)/d
	else:
		v = Vector2(x,y)
	return v 



func _on_player_two_goal_body_entered(body):
	body.position = Vector2(640,400)
	body.velocity = Vector2(0,0)
	player_one_score_label.text = str(int(player_one_score_label.text)+1)


func _on_player_one_goal_body_entered(body):
	body.position = Vector2(640,400)
	body.velocity = Vector2(0,0)
	player_two_score_label.text = str(int(player_two_score_label.text)+1)


func _on_player_two_area_body_entered(body):
	if body.is_in_group("ball"):
		var new_vect = Vector2(ball.position.x - (player_two.position.x+75), ball.position.y - player_two.position.y)
		new_vect = new_vect/sqrt(new_vect.x**2 + new_vect.y**2)
		ball.velocity = new_vect * (ball_speed + ball_speed_delta)
		ball_speed_delta += 10

func _on_player_one_area_body_entered(body):
	if body.is_in_group("ball"):
		var new_vect = Vector2(ball.position.x - (player_one.position.x-75), ball.position.y - player_one.position.y)
		new_vect = new_vect/sqrt(new_vect.x**2 + new_vect.y**2)
		ball.velocity = new_vect * (ball_speed + ball_speed_delta)
		ball_speed_delta += 10
		ball.move_and_slide()
