extends Node2D

var speed = 100
var chicken_points =0
var waddle = 1
var corn = preload("res://corn.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Node/Player.velocity = Vector2(0,0)
	if Input.is_action_pressed("up"):
		$Node/Player.velocity += Vector2(0,-1 * speed)
	if Input.is_action_pressed("down"):
		$Node/Player.velocity += Vector2(0,1 * speed)
	if Input.is_action_pressed("left"):
		$Node/Player.velocity += Vector2(-1* speed,0)
		$Node/Player/Sprite2D.scale.x = .5
	if Input.is_action_pressed("right"):
		$Node/Player.velocity += Vector2( speed,0)
		$Node/Player/Sprite2D.scale.x = -.5
	$Node/Player.move_and_slide()
	if $Node/Player.velocity != Vector2(0,0):
		$Node/Player/Sprite2D.skew = sin(waddle*delta*50)*.05
		waddle+=1
	


func _on_mouth_area_entered(area):
	print("I'm on corn!")
	chicken_points += 1
	$points.text = str(chicken_points)
	_eat_corn()
	_make_corn()
	
	

func _eat_corn():
	for corn in $Node/Corns.get_children():
		corn.queue_free()
	
func _make_corn():
	var new_corn = corn.instantiate()
	new_corn.position = Vector2(randi_range(10,1100),randi_range(10,640))
	$Node/Corns.add_child(new_corn)
	
