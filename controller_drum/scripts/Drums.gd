extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if(event.is_action_pressed("Kick")):
		$Kick.play()
	if(event.is_action_pressed("SnareLeft")):
		$SnareLeft.play()
	if(event.is_action_pressed("SnareRight")):
		$SnareRight.play()
	if(event.is_action_pressed("Crash")):
		$Crash.play()
	if(event.is_action_pressed("Splash")):
		$Splash.play()
	if(event.is_action_pressed("FloorTom")):
		$FloorTom.play()
	if(event.is_action_pressed("MidTom")):
		$MidTom.play()
	if(event.is_action_pressed("Hat")):
		if(Input.is_action_pressed("HatPedal")):
			$HatClosed.play()
		else:
			$HatOpen.play()
