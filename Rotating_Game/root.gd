extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_up():
	if abs($"Game Area".position.y) < 0.1:
		$"Game Area".rotate(deg_to_rad(-90))
		$"Game Area".position.y = 1560
	else:
		$"Game Area".rotation = 0.0
		$"Game Area".position.y = 0.0
