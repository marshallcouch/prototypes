extends Node2D

var player_moves = [{"up":0.00, "back":0.00, "forward":0.00, "down":0.0}, {"up":0.00, "back":0.00, "forward":0.00, "down":0.0}]
var player_timeout = [0.0,0.0]
@onready var players = [$PlayerOne,$PlayerTwo]
const COMBO_TIMER = .5
const MOVE_TIMOUT = .3

const PLAYER_SPEED = 100.0

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_coffee_table_controls(0,delta)
	_coffee_table_controls(1,delta)

func _coffee_table_controls(player, delta):
	var x = 0.0
	var y = 0.0

	if player == 0:
		x = Input.get_joy_axis(0,JOY_AXIS_LEFT_X)
		y = Input.get_joy_axis(0,JOY_AXIS_LEFT_Y)
	elif player==1:
		x = Input.get_joy_axis(0,JOY_AXIS_RIGHT_X)
		y = Input.get_joy_axis(0,JOY_AXIS_RIGHT_Y)
	if player_timeout[player] >0.0:
		player_timeout[player] -= delta
		return
	if  abs(x) + abs(y) < .25:
		players[player].play_animation("Stand")
	if abs(x) > abs(y) and abs(x) > .5:
		if x > 0 :
			if player ==0:
				player_moves[player]["forward"] = COMBO_TIMER
				players[player].position.x += delta * PLAYER_SPEED
				players[player].play_animation("Walk")
				players[player].set_blocking(false)
			else:
				player_moves[player]["back"] = COMBO_TIMER
				players[player].position.x += delta * PLAYER_SPEED
				players[player].play_animation("Block")
				players[player].set_blocking(true)
		else: 
			if player == 0:
				player_moves[player]["back"] = COMBO_TIMER
				players[player].position.x -= delta * PLAYER_SPEED
				players[player].play_animation("Block")
				players[player].set_blocking(true)
			else:
				player_moves[player]["forward"] = COMBO_TIMER
				players[player].position.x -= delta * PLAYER_SPEED
				players[player].play_animation("Walk")
				players[player].set_blocking(false)
			
	elif abs(x) < abs(y) and abs(y) > .5:
		if y < 0:
			player_moves[player]["up"] = COMBO_TIMER
		else:
			player_moves[player]["down"] = COMBO_TIMER
	for direction in player_moves[player]:
		player_moves[player][direction] -= delta
	_check_for_move(player)
	
func _check_for_move(player):
	var up = player_moves[player]["up"]
	var down = player_moves[player]["down"]
	var back = player_moves[player]["back"]
	var forward = player_moves[player]["forward"] 
	if player_moves[player]["back"] > 0.0 and player_moves[player]["forward"] >0.0 and (player_moves[player]["up"] > 0.0 or player_moves[player]["down"] >0.0):
		if player_moves[player]["back"] < player_moves[player]["forward"]:
			if player_moves[player]["up"] >= player_moves[player]["back"] and  player_moves[player]["up"] <= player_moves[player]["forward"] :
				#punch
				print("punch")
				players[player].punch()
				player_timeout[player] = MOVE_TIMOUT
				for direction in player_moves[player]:
					player_moves[player][direction] = 0.0
			elif player_moves[player]["down"] >= player_moves[player]["back"] and  player_moves[player]["down"] <= player_moves[player]["forward"] :
				players[player].kick()
				player_timeout[player] = MOVE_TIMOUT
				for direction in player_moves[player]:
					player_moves[player][direction] = 0.0
				
