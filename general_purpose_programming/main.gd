extends Node2D

@onready var console:Label = $ScrollContainer/Label
var thread
# Called when the node enters the scene tree for the first time.
func _ready():
	thread = Thread.new()
	thread.start(main)

func main():
	var i:int = 1
	var j:int
	var is_prime:bool = true

	while true:
		i+=1
		is_prime= true
		j = ceil(i/2.0)
		while j > 1:
			if i % j == 0:
				is_prime = false
				break
			j -=1
		if is_prime:
			call_deferred("pl",i)
		await get_tree().create_timer(.00001).timeout
	
			
	


func pl(new_text:Variant = ""):
	console.text = str(new_text) + "\n" + console.text

func p(new_text:Variant = ""):
	console.text += str(new_text)
