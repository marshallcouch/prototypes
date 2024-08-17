#Kill the Game
get_tree().quit()


#preloads
var my_preload = preload("res://scenes/boss.tscn")
my_preload.instantiate()

#onready variables for nodes
@onready var soundtrack = $MusicPlayer






Shaders:
//get the entire screen
uniform sampler2D screen_texture: hint_screen_texture;

material.set_shader_parameter("uniform_value", 123)