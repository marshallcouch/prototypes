extends Node
@onready var player_one = $Players/PlayerOne
@onready var player_one_shape = $Players/PlayerOne/PlayerShape
@onready var player_two = $Players/PlayerTwo
@onready var player_two_shape = $Players/PlayerTwo/PlayerShape
@onready var tails = $Tails
var tail = preload("res://scenes/light_cycles/tail_node.tscn")

var last_tails = [Vector2(0,0),Vector2(0,0)]
var player_speed = 300
var player_speed_delta = 0
const DEAD_ZONE:float = .15
const MAX_ANALOG:float = .85
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	player_movement(player_one, player_one_shape, 0)
	player_movement(player_two, player_two_shape, 1)



func player_movement(player: Node,shape:Node,player_number:int):
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
	var old_velocity = player.velocity
	if abs(x) > abs(y) and abs(x) > .5:
		player.velocity = Vector2(x/abs(x),0) * (player_speed+ player_speed_delta)
		shape.rotation = 0
	elif abs(x) < abs(y) and abs(y) > .5:
		player.velocity = Vector2(0,y/abs(y)) * (player_speed + player_speed_delta)
		shape.rotation = PI/2
	if player.velocity == Vector2(0,0):
		if player_number == 0:
			player.velocity = Vector2(1,0) * (player_speed+ player_speed_delta)
		else:
			player.velocity = Vector2(-1,0) * (player_speed+ player_speed_delta)
	if distance(last_tails[player_number],player.position) > 8 or old_velocity != player.velocity:
		var new_tail = tail.instantiate()
		tails.add_child(new_tail)
		new_tail.position = player.position
		last_tails[player_number] = player.position
	player.move_and_slide()
	
func distance(pos1, pos2) -> float:
	return sqrt((pos1.x-pos2.x)**2 + (pos1.y-pos2.y)**2)
	
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
