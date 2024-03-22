extends CharacterBody2D

@export var PROJECTILE_SPEED: float = 300
var projectile_damage = 10

func _ready():
	velocity = velocity*PROJECTILE_SPEED
	
func _process(_delta):
	move_and_slide()


func _on_timer_timeout():
	self.queue_free()
