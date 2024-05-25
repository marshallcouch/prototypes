extends Node2D


const ENEMY_BASE_SPEED = .1
var enemy_speed = .1
@onready var player_paths = [$PlayerOnePath,$PlayerTwoPath]
@onready var player_lines = [$PlayerOneLine,$PlayerTwoLine]

# Called when the node enters the scene tree for the first time.
func _ready():
	create_paths()
	
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

		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for player_path in player_paths:
		for enemy in player_path.get_children():
			enemy.progress_ratio += delta * enemy_speed
	
