extends CharacterBody2D

var player_source = -1

signal player_scored(player_num)

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Enemy"):
		area.get_parent().queue_free()
		player_scored.emit(player_source)
		queue_free()
		
func _physics_process(delta):
	if position.x < 0 or position.x > 1280 or position.y <0 or position.y >800:
		queue_free()
	move_and_slide()
		
