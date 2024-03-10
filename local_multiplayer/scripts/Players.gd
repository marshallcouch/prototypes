extends Node

var SPEED = 100
var MAX_SPEED = 300
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	if Input.get_joy_axis(0,JOY_AXIS_LEFT_X) > 0.1:
		$Player.velocity += Vector2(SPEED,0)
	elif Input.get_joy_axis(0,JOY_AXIS_LEFT_X) < -0.1:
		$Player.velocity += Vector2(-SPEED,0)
	else: 
		$Player.velocity -= Vector2($Player.velocity.x,0)
	if Input.get_joy_axis(0,JOY_AXIS_LEFT_Y) > 0.1:
		$Player.velocity += Vector2(0,SPEED)
	elif Input.get_joy_axis(0,JOY_AXIS_LEFT_Y) < -0.1:
		$Player.velocity += Vector2(0,-SPEED)
	else:
		$Player.velocity -= Vector2(0,$Player.velocity.y)
	$Player.velocity = $Player.velocity.clamp(Vector2(-MAX_SPEED,-MAX_SPEED), Vector2(MAX_SPEED,MAX_SPEED))
	$Player.move_and_slide()
	
func _input(event):
	if Input.is_joy_button_pressed(0,JOY_BUTTON_A):
		print("bleh")
