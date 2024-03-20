extends Node2D

const SPEED = 300
const DEAD_ZONE = .15
const VEL_MIN = Vector2(-SPEED*.5, -SPEED*.5)
const VEL_MAX = Vector2(SPEED*.5, SPEED*.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Player1  
	#P1I = Player 1 Input
	#P1V = Player 1 Velocity
	var P1I =  Vector2(Input.get_joy_axis(0,JOY_AXIS_LEFT_X),Input.get_joy_axis(0,JOY_AXIS_LEFT_Y))
	var total_vector = sqrt(P1I.x**2 + P1I.y**2)
	var P1V = Vector2(P1I.x/(abs(P1I.x)+abs(P1I.y)),P1I.y/(abs(P1I.x)+abs(P1I.y)))*total_vector
	print(sqrt(P1V.x**2 + P1V.y**2))
	if DEAD_ZONE < total_vector:
		$Player1.velocity = (P1V) * SPEED
		$Player1.velocity.clamp(VEL_MIN,VEL_MAX)
		$Player1.move_and_slide()

	#Player1  
	#P1I = Player 1 Input
	#P1V = Player 1 Velocity
	var P2I =  Vector2(Input.get_joy_axis(0,JOY_AXIS_RIGHT_X),Input.get_joy_axis(0,JOY_AXIS_RIGHT_Y))
	var total2_vector = sqrt(P2I.x**2 + P2I.y**2)
	var P2V = Vector2(P2I.x/(abs(P2I.x)+abs(P2I.y)),P2I.y/(abs(P2I.x)+abs(P2I.y)))*total2_vector
	print(sqrt(P2V.x**2 + P2V.y**2))
	if DEAD_ZONE < total2_vector:
		$Player2.velocity = (P2V) * SPEED
		$Player2.velocity.clamp(VEL_MIN,VEL_MAX)
		$Player2.move_and_slide()

