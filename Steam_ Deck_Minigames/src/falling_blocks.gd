extends Node


#640, 400

var drop_speed = .75
var grid_start_x = 40
var grid_end_x = 1240
var grid_start_y = 250
var grid_end_y = 550
var grid_size = 30

var player_start_block = [Vector2(595,385),Vector2(685,415)]
var player_active_blocks = [[],[]]
var drop_vector = [Vector2(-30,0),Vector2(30,0)]

@onready var player_drop_timer = [$PlayerOneDropTimer, $PlayerTwoDropTimer]
@onready var player_movement_delay = [0.0, 0.0]
@onready var player_blocks = [$PlayerOneBlocks,$PlayerTwoBlocks] 
@onready var player_scores = [$PlayerOneScore,$PlayerTwoScore] 
@onready var background = $Background

var block = preload("res://scenes/falling_blocks/block.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	draw_grid()



func draw_grid():
	for i in range(grid_start_y,grid_end_y+1,grid_size):
		var line = Line2D.new()
		line.add_point(Vector2(grid_start_x,i))
		line.add_point(Vector2(grid_end_x,i))
		line.width = 2
		line.self_modulate = Color("#AAAAAA")
		background.add_child(line)
	for i in range(grid_start_x, grid_end_x+1,grid_size):
		var line = Line2D.new()
		line.add_point(Vector2(i, grid_start_y))
		line.add_point(Vector2(i, grid_end_y))
		line.width = 2
		line.self_modulate = Color("#AAAAAA")
		background.add_child(line)
	var line = Line2D.new()
	line.add_point(Vector2(640,0 ))
	line.add_point(Vector2(640, 800))
	line.width = 2
	line.self_modulate = Color("#FFFFFF")
	background.add_child(line)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(0,2):
		player_movement_delay[i] -= delta
		_coffee_table_controls(i)
		
var wait_time_for_movement = .2
func _coffee_table_controls(player):
	if player_movement_delay[player] > 0.001:
		return
	var x = 0.0
	var y = 0.0
	var delay = false
	if player == 0:
		x = Input.get_joy_axis(0,JOY_AXIS_LEFT_X)
		y = Input.get_joy_axis(0,JOY_AXIS_LEFT_Y)
	elif player==1:
		x = Input.get_joy_axis(0,JOY_AXIS_RIGHT_X)
		y = Input.get_joy_axis(0,JOY_AXIS_RIGHT_Y)
	if abs(x) > abs(y) and abs(x) > .5:
		if x > 0 :
			if player ==0:
				rotate(player_active_blocks[player], player_blocks[player])
				delay = true
			else:
				update_positions(player_active_blocks[player],drop_vector[player],player_blocks[player])
		else: 
			if player == 1:
				rotate(player_active_blocks[player], player_blocks[player])
				delay = true
			else:
				update_positions(player_active_blocks[player],drop_vector[player],player_blocks[player])
	elif abs(x) < abs(y) and abs(y) > .5:
		if y < 0:
			update_positions(player_active_blocks[player], Vector2(0,-30), player_blocks[player])
			delay = true
		else:
			update_positions(player_active_blocks[player], Vector2(0,30), player_blocks[player])
			delay = true
	if delay:
		player_movement_delay[player] =  wait_time_for_movement
			
func drop_blocks():
	for i in 2:
		if player_active_blocks[i] == []:
			get_block(i)
		else:
			if !update_positions(player_active_blocks[i],drop_vector[i],player_blocks[i]):
				for block in player_active_blocks[i]:
					block.is_locked = true
				check_for_line_clear(i)
				check_for_loss(i)
				player_active_blocks[i] = []

func check_for_line_clear(player:int):
	var lines = {}
	var lines_to_clear = []
	for bl in player_blocks[player].get_children():
		if lines.has(bl.position.x):
			lines[bl.position.x] +=1
			if lines[bl.position.x] ==10:
				lines_to_clear.append(bl.position.x)
		else:
			lines[bl.position.x] = 1
			
	lines_to_clear.sort()
	if player ==1:
		lines_to_clear.reverse()
	var offset = Vector2(0,0)
	for line in lines_to_clear:
		player_scores[player].text = str(int(player_scores[player].text)+1)
		for bl in player_blocks[player].get_children():
			if bl.position.x == line+offset.x:
				bl.queue_free()
			if player ==0:
				if bl.position.x > line+offset.x:
					bl.position += drop_vector[player]
			elif player==1:
				if bl.position.x < line+offset.x:
					bl.position +=  drop_vector[player]
		offset+=drop_vector[player]
	
	
func check_for_loss(player: int):
	for bl in player_blocks[player].get_children():
		if bl.position.x == player_start_block[player].x and bl.is_locked==true:
			if player ==0:
				player_scores[1].text = str(int(player_scores[1].text)+10)
			if player ==1:
				player_scores[0].text = str(int(player_scores[0].text)+10)
			reset()
			return
	

func rotate(blocks,player_blocks):
	if blocks == []:
		return
	var rotate_point:Vector2 = blocks[0].position
	var new_block_position = []
	for bl in blocks:
		var new_position = (rotate_point - bl.position)
		new_position = Vector2(-new_position.y,new_position.x)
		new_position = new_position + rotate_point
		new_block_position.append(new_position)
		for placed_block in player_blocks.get_children():
			if placed_block.is_locked:
				if new_position == placed_block.position:
					return false
		if new_position.x >= grid_end_x or new_position.x <= grid_start_x:
			return false
		if new_position.y >= grid_end_y or new_position.y <= grid_start_y:
			return false
	var i = 0
	for bl in blocks:
		bl.position = new_block_position[i]
		i+=1
	return true

func update_positions(blocks,movement,player_blocks) -> bool:
	for bl in blocks:
		for placed_block in player_blocks.get_children():
			if placed_block.is_locked:
				if bl.position + movement == placed_block.position:
					return false
		if (bl.position+movement).x >= grid_end_x or (bl.position+movement).x <= grid_start_x:
			return false
		if (bl.position+movement).y >= grid_end_y or (bl.position+movement).y <= grid_start_y:
			return false
	for bl in blocks:
		bl.position += movement
	return true
	
const BLOCK_GROUPS = [[Vector2(0,0), Vector2(0,30),Vector2(30,0),Vector2(30,30)],#square
	[Vector2(0,0), Vector2(0,-30),Vector2(0,30),Vector2(0,60)], #line
	[Vector2(0,0), Vector2(0,-30),Vector2(0,30),Vector2(30,30)], #L
	[Vector2(0,0), Vector2(0,-30),Vector2(0,30),Vector2(30,-30)], #ReverseL
	[Vector2(0,0), Vector2(0,30),Vector2(30,0),Vector2(30,-30)], #Z
	[Vector2(0,0), Vector2(0,-30),Vector2(30,0),Vector2(30,30)], #ReverseZ
	[Vector2(0,0), Vector2(0,-30),Vector2(0,30),Vector2(30,0)]#PartialE
	]
func get_block(player:int):
	var block_shape = randi_range(0,BLOCK_GROUPS.size()-1)
	for i in range(0,4):
		var new_block = block.instantiate()
		if player ==0:
			new_block.position = player_start_block[player] + BLOCK_GROUPS[block_shape][i]
		elif player ==1:
			new_block.position = player_start_block[player] - BLOCK_GROUPS[block_shape][i]
		player_active_blocks[player].append(new_block)
		player_blocks[player].add_child(new_block)

func _on_player_one_drop_timer_timeout():
	drop_blocks()
	
func reset():
	for i in range(0,2):
		for blocks in player_blocks[i].get_children():
			blocks.queue_free()
	player_active_blocks= [[],[]]


func _on_player_one_movement_timer_timeout():
	pass # Replace with function body.
