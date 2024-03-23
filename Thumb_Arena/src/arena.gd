extends Node

var player_preload = preload("res://scenes/player.tscn")
@onready var players_node = $Controls/Players
var boundary_x: int = 1280
var boundary_y:int = 800
var BW = 50 #boundary_width
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 2:
		var player = player_preload.instantiate()
		players_node.add_child(player)
		player.position.x = 300*(i+1)
		player.position.y = 300
	#_generate_obstacles()
	_generate_boundaries()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_restart_button_up():
	for player in players_node.get_children():
		player.queue_free()
	for projectile in $Projectiles.get_children():
		projectile.queue_free()
	_ready()


func _on_quit_button_up():
	get_tree().quit()

func _generate_boundaries():
	var points: PackedVector2Array = [Vector2(0,-BW),
									Vector2(0,boundary_y+BW),
									Vector2(-BW,boundary_y+BW),
									Vector2(-BW,-BW)]
	_generate_obstacle(points,Vector2(0,0), "Wall")
	_generate_obstacle(points,Vector2(boundary_x+BW,0), "Wall")
	var points2: PackedVector2Array = [Vector2(-BW,0),
									Vector2(boundary_x +BW,0),
									Vector2(boundary_x+BW,-BW),
									Vector2(-BW,-BW)]
	_generate_obstacle(points2,Vector2(0,0), "Wall")
	_generate_obstacle(points2,Vector2(0,boundary_y+BW), "Wall")

func _generate_obstacle(points: PackedVector2Array, position:Vector2 = Vector2(0,0),type:String = "Obstacle"):
	var obstacle = StaticBody2D.new()
	var obstacleCollision = CollisionPolygon2D.new()
	var obstaclePolygon = Polygon2D.new()
	obstacleCollision.polygon = points
	obstaclePolygon.polygon = points
	obstacle.add_child(obstacleCollision)
	obstacle.add_child(obstaclePolygon)
	obstacle.add_to_group(type)
	obstacle.position = position
	$Obstacles.add_child(obstacle)



#need to update to use new function
func _generate_obstacles():
	var points: PackedVector2Array
#	var points2: PackedVector2Array
	for i in 3:
		points.append(Vector2(randi_range(0,200), randi_range(0,200)))
	var obstacle = StaticBody2D.new()
	var obstacleCollision = CollisionPolygon2D.new()
	var obstaclePolygon = Polygon2D.new()
#	var obstacleOutline = Line2D.new()
#	var obstacleOutline2 = Line2D.new()
	obstacleCollision.polygon = points
	obstaclePolygon.polygon = points
#	obstacleOutline.points = points
#	points2.append(points[0])
#	points2.append(points[2])
#	obstacleOutline2.points = points2
#	obstacleOutline.default_color = Color("red")
#	obstacleOutline2.default_color = Color("red")
	obstacle.add_child(obstacleCollision)
	obstacle.add_child(obstaclePolygon)
#	obstacle.add_child(obstacleOutline)
#	obstacle.add_child(obstacleOutline2)
	obstacle.position = Vector2(randi_range(100,1180), randi_range(100,700))
	obstacle.add_to_group("Obstacle")
	$Obstacles.add_child(obstacle)
	
		
		

