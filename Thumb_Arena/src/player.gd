extends CharacterBody2D

var projectile = preload("res://scenes/projectile.tscn")

func _shoot():
	#check if we should shoot
#	if get_node("/root/World/MainMenu").visible:
#		return

	for player in get_node("/root/Arena/Controls/Players").get_children():
		if self != player:
			var vector_diff = player.position - self.position
			var total_x_y = sqrt(vector_diff.x**2 + vector_diff.y**2)
			var new_projectile = projectile.instantiate()
			new_projectile.position = self.position
			
			#need to get the location of the other player and shoot towards them
			new_projectile.velocity = Vector2(vector_diff.x,vector_diff.y)/total_x_y
			get_node("/root/Arena/Projectiles").add_child(new_projectile)

