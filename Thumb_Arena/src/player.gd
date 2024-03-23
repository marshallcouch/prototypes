extends CharacterBody2D

var health: int = 100
var projectile = preload("res://scenes/projectile.tscn")
var DIST_FROM_ORIGINATOR = 100


func _shoot():
	for player in get_node("/root/Arena/Controls/Players").get_children():
		if self != player:
			shoot_at_player(player)

func shoot_at_player(player: Node2D):
	var vector_diff = player.position - self.position
	var total_x_y = sqrt(vector_diff.x**2 + vector_diff.y**2)
	var vector_to_other_player = Vector2(vector_diff.x,vector_diff.y)/total_x_y
	var new_projectile = projectile.instantiate()
	new_projectile.position = self.position + vector_to_other_player * DIST_FROM_ORIGINATOR
	#need to get the location of the other player and shoot towards them
	new_projectile.velocity = vector_to_other_player
	get_node("/root/Arena/Projectiles").add_child(new_projectile)

func _on_hit_box_body_entered(body):
	if body.is_in_group("Projectile"):
		self.health -= body.projectile_damage
		body.queue_free()
		$HealthBar.value = health
	if health <= 0:
		self.queue_free()
	if body.is_in_group("Powerup"):
		pass
