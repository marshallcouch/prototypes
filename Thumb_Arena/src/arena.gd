extends Node

var player_preload = preload("res://scenes/player.tscn")
@onready var players_node = $Controls/Players
var test = "testing"
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 2:
		var player = player_preload.instantiate()
		players_node.add_child(player)
		player.position.x = 300*(i+1)
		player.position.y = 300
	_generate_obstacle()


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
	
func _generate_obstacle():
	var points: PackedVector2Array
	var points2: PackedVector2Array
	for i in 3:
		points.append(Vector2(randi_range(0,200), randi_range(0,200)))
	var obstacle = StaticBody2D.new()
	var obstacleCollision = CollisionPolygon2D.new()
	var obstaclePolygon = Polygon2D.new()
	var obstacleOutline = Line2D.new()
	var obstacleOutline2 = Line2D.new()
	obstacleCollision.polygon = points
	obstaclePolygon.polygon = points
	obstacleOutline.points = points
	points2.append(points[0])
	points2.append(points[2])
	obstacleOutline2.points = points2
	obstacleOutline.default_color = Color("red")
	obstacleOutline2.default_color = Color("red")
	obstacle.add_child(obstacleCollision)
	obstacle.add_child(obstaclePolygon)
	obstacle.add_child(obstacleOutline)
	obstacle.add_child(obstacleOutline2)
	obstacle.position = Vector2(randi_range(100,1180), randi_range(100,700))
	obstacle.add_to_group("Obstacle")
	$Obstacles.add_child(obstacle)
	
		
		

