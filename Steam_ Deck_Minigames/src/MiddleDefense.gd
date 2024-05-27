extends Node2D


const ENEMY_BASE_SPEED = .1
var enemy_speed = .1
var enemy_spawn_time = 5
var projectile_speed = 500


@onready var player_paths = [$PlayerOnePath,$PlayerTwoPath]
@onready var player_lines = [$PlayerOneLine,$PlayerTwoLine]
@onready var player_scores = [$PlayerOneScore,$PlayerTwoScore]
@onready var enemy_spawn_timer = $EnemySpawnTimer
@onready var player_cannons = [$PlayerOne/Cannon,$PlayerTwo/Cannon]
@onready var player_origins = [Vector2(0,400),Vector2(1280,400)]

var projectile = preload("res://scenes/middle_defense/projectile.tscn")
var enemy = preload("res://scenes/middle_defense/enemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	create_paths()
	spawn_enemies()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for player_path in player_paths:
		for enemy in player_path.get_children():
			enemy.progress_ratio += delta * enemy_speed
	_coffee_table_control(0)
	_coffee_table_control(1)

func spawn_enemies():
	var new_enemy
	for i in player_paths.size():
		new_enemy = enemy.instantiate()
		player_paths[i].add_child(new_enemy)
	
func create_paths():
	for i in player_paths.size():
		player_paths[i].curve.clear_points()
		player_lines[i].clear_points()
		player_paths[i].curve.add_point(Vector2(0,-30))
		player_lines[i].add_point(Vector2(0,-30))
		
	var new_point = Vector2(0,0)
	for j in range(200,600,75):
		new_point.x = randi_range(-300,300)
		new_point.y = randi_range(j-180,j+180)
		for i in player_paths.size():
			player_paths[i].curve.add_point(new_point)
			player_lines[i].add_point(new_point)
			new_point.x *=-1
			
	for i in player_paths.size():
		player_paths[i].curve.add_point(Vector2(0,830))
		player_lines[i].add_point(Vector2(0,830))



func _on_enemy_spawn_timer_timeout():
	spawn_enemies()
	enemy_spawn_timer.start(enemy_spawn_time)
	if enemy_spawn_time > 1.5:
		enemy_spawn_time *= .95


func _on_player_one_hit_box_area_entered(area):
	if area.get_parent().is_in_group("Enemy"):
		player_scores[0].text = str(int(player_scores[0].text)-1)
		area.get_parent().queue_free()


func _on_player_two_hit_box_area_entered(area):
	if area.get_parent().is_in_group("Enemy"):
		player_scores[1].text = str(int(player_scores[0].text)-1)
		area.get_parent().queue_free()

func reset():
	for i in player_paths.size():
		for enemy in player_paths[i].get_children():
			enemy.queue_free()
		player_scores[i].text = "0"
	for projectile_node in $projectiles.get_children():
		projectile_node.queue_free()
	create_paths()
	spawn_enemies()


const DEAD_ZONE:float = .15
const MAX_ANALOG:float = .0
	
	
func _coffee_table_control(player):
	var x:float = 0
	var y:float = 0
	if player == 0:
		x = Input.get_joy_axis(0,JOY_AXIS_LEFT_X)
		y = Input.get_joy_axis(0,JOY_AXIS_LEFT_Y)
	if player == 1:
		x = Input.get_joy_axis(0,JOY_AXIS_RIGHT_X)
		y = Input.get_joy_axis(0,JOY_AXIS_RIGHT_Y)
	
	var offset =_x_y_movement(x,y)
	
	if Vector2(0,0)== offset:
		if player ==0:
			offset = Vector2(1,0)
		else: 
			offset = Vector2(-1,0)
		
	player_cannons[player].points[1] = player_origins[player] + (offset*40)


	

func update_player_score(player):
	player_scores[player].text = str(int(player_scores[player].text)+1)

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

func _on_projectile_timer_timeout():
	for i in player_paths.size():
		var new_projectile = projectile.instantiate()
		new_projectile.player_source = i
		new_projectile.velocity = ((player_cannons[i].points[1] -player_origins[i]) *projectile_speed)/40
		new_projectile.connect("player_scored", update_player_score)
		new_projectile.position = player_origins[i]
		$projectiles.add_child(new_projectile)
